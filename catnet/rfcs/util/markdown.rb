require 'kramdown'
require 'ruby-progressbar'

def supply
  puts 'Please supply a subcommand.'
end

def usage
  puts '''Usage: rfc_util.rb [SUBCOMMAND]

Subcommands:
    pull    Pull the newest RFCs in markdown form.
    html    Transpile all the markdown into HTML. Takes a file or \'all\' for all.'''
end

def pull
  Dir.chdir('../../../')

  system('git fetch catnet-rfcs main')
  system('git subtree pull --prefix catnet/rfcs/markdown catnet-rfcs main --squash')
end

def transpile(file)
  template_data = File.open('template.html').read
  markdown_data = File.open(file).read
  html_data = Kramdown::Document.new(markdown_data).to_html

  template_data = template_data.gsub('<!-- TITLE -->', markdown_data.lines.first.chomp)
  template_data = template_data.gsub('<!-- HTML -->', html_data)

  return template_data
end

def get_new_index
  template_data = File.open('index.template.html').read
  template_entry = '''<div style="padding-bottom: 25px">
<a class="no-underline h5 bold text-accent" title="rfc-0-standardising-rfcs.html" href="<!-- HTML FILE -->">RFC <!-- RFC --></a>
<h2 class="h1 lh-condensed col-9 mt-0"><a class="link-primary" title="rfc-0-standardising-rfcs.html" href="<!-- HTML FILE -->"><!-- TITLE --></a></h2>
<a class="no-underline h5 bold text-accent" href="<!-- MARKDOWN FILE -->">download raw</a>
</div>
<br/>'''
  total = ""

  Dir.entries("../html").each do |file|
    if file == '.' or file == '..'
      next
    end

    current = template_entry
    markdown_file = "./markdown/" + file.gsub(".html", ".md")
    markdown_data = File.open("." + markdown_file).read

    current = current.gsub('<!-- HTML FILE -->', './html/' + file)
    current = current.gsub('<!-- MARKDOWN FILE -->', markdown_file)
    current = current.gsub('<!-- TITLE -->', markdown_data.lines.first)
    current = current.gsub('<!-- RFC -->', file.split('-')[1])

    total.prepend(current)
  end

  template_data = template_data.gsub('<!-- INDEX -->', total)

  return template_data
end

if ARGV.length == 0
  supply  

  exit
elsif ARGV[0] == '--help' or ARGV[0] == '-h'
  usage

  exit
elsif ARGV[0] == 'pull'
  pull

  exit
elsif ARGV[0] == 'html'
  if ARGV.length == 1
    puts 'Please supply (a) markdown file(s).'
    exit
  end

  progressbar = ProgressBar.create(:total => ARGV.length - 1, :length => 100, :progress_mark => '#', :remainder_mark => '-')

  ARGV.drop(1).each do |file|
    friendly = file.split('/')[-1].gsub('.md', '')

    progressbar.log friendly + '...'

    File.open('../html/' + friendly + '.html', 'w') { |f| f.write transpile(file) }

    progressbar.increment
  end

  puts 'Writting index...'
  File.open('../index.html', 'w') { |f| f.write get_new_index }

  exit
end

