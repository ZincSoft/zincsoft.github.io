# require 'commonmarker'
# require 'commonmarker/rouge'
# puts CommonMarker::Rouge.render_html(File.open(ARGV[0]).read, [:DEFAULT], [:UNSAFE, :SOURCEPOS], [:table, :strikethrough, :tagfilter])

require 'kramdown'

puts Kramdown::Document.new(File.open(ARGV[0]).read).to_html
