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
  Dir.chdir('../../../../../')

  system('git fetch catnet-rfcs main')
  system('git subtree pull --prefix src/catnet/markdown catnet-rfcs main --squash')
end

def transpile(file)
  template_data = File.open('rfc_x.html.template').read
  markdown_data = File.open(file).read
  html_data = Kramdown::Document.new(markdown_data).to_html

  html_data = html_data.gsub("<p ", "<p class=\"text-xl lg:text-justify tracking-wide\" ")
  html_data = html_data.gsub("<p>", "<p class=\"text-xl lg:text-justify tracking-wide\">")
  html_data = html_data.gsub("<h1 ", "<h1 class=\"pt-8 font-display font-bold text-4xl md:text-6xl\" ")
  html_data = html_data.gsub("<h2 ", "<h2 class=\"pt-8 font-display font-bold text-3xl md:text-5xl\" ")
  html_data = html_data.gsub("<h3 ", "<h3 class=\"pt-8 font-display font-bold text-2xl md:text-4xl\" ")
  html_data = html_data.gsub("<h4 ", "<h4 class=\"pt-8 font-display font-bold text-2xl md:text-4xl\" ")
  html_data = html_data.gsub("<table>", "<table class=\"pt-16 text-xl lg:text-justify tracking-wide\">")
  html_data = html_data.gsub("<ol>", "<ol class=\"text-xl lg:text-justify tracking-wide\">")

  template_data = template_data.gsub('<!-- TITLE -->', markdown_data.lines.first.chomp)
  template_data = template_data.gsub('<!-- HTML -->', html_data)

  return template_data
end

def get_new_index
  index = File.open('index.html.template').read
  template_entry = File.open('entry.html.template').read
  total = ""

  Dir.entries("../html").each do |file|
    if file == '.' or file == '..'
      next
    end

    if not file.include? "html"
      next
    end

    current = template_entry

    puts file.gsub(".html", ".md")
    markdown_file = "./markdown/" + file.gsub(".html", ".md")
    markdown_data = File.open("." + markdown_file).read
    current = current.gsub('<!-- HTML FILE -->', './html/' + file)
    current = current.gsub('<!-- MARKDOWN FILE -->', markdown_file)
    current = current.gsub('<!-- TITLE -->', markdown_data.lines.first)
    current = current.gsub('<!-- RFC -->', file.split('-')[1])

    total.prepend(current)
  end

  index = index.gsub('<!-- INDEX -->', total)

  return index
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

  # progressbar = ProgressBar.create(:total => ARGV.length - 1, :length => 100, :progress_mark => '#', :remainder_mark => '-')

  ARGV.drop(1).each do |file|
    friendly = file.split('/')[-1].gsub('.md', '')

    # progressbar.log friendly + '...'
    puts friendly + '...'

    File.open('../html/' + friendly + '.html', 'w+') { |f| f.write transpile(file) }

    # progressbar.increment
  end

  puts 'Writting index...'
  File.open('../index.html', 'w') { |f| f.write get_new_index }

  exit
end

