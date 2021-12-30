# require 'commonmarker'
# require 'commonmarker/rouge'
# puts CommonMarker::Rouge.render_html(File.open(ARGV[0]).read, [:DEFAULT], [:UNSAFE, :SOURCEPOS], [:table, :strikethrough, :tagfilter])

require 'kramdown'

if ARGV.length == 0
  puts 'Please supply a subcommand.'
  exit
elsif ARGV[0] == '--help' or ARGV[0] == '-h'
  puts '''Usage: rfc_util.rb [SUBCOMMAND]

Subcommands:
    pull    Pull the newest RFCs in markdown form.
    html    Transpile all the markdown into HTML.'''
elsif ARGV[0] == 'pull'
  Dir.chdir('../../')

  system('git fetch catnet-rfcs main')
  system('git subtree pull --prefix catnet/rfcs/markdown catnet-rfcs main --squash')
elsif ARGV[0] == 'html'
  if ARGV.length == 1
    puts 'Please supply a markdown file.'
    exit
  end

  template_data = File.open('template.html').read
  markdown_data = File.open(ARGV[1]).read
  html_data = Kramdown::Document.new(markdown_data).to_html

  template_data = template_data.gsub('<!-- TITLE -->', markdown_data.lines.first.chomp)
  template_data = template_data.gsub('<!-- HTML -->', html_data)

  puts template_data
end

# puts Kramdown::Document.new(File.open(ARGV[0]).read).to_html
