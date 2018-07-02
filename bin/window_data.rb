# gem install win32-window --pre
require 'win32/window'

title = ARGV[0]
this_file = File.basename(__FILE__)

if ARGV.size.zero?
  STDERR.puts "\n    #{this_file.upcase} <window_title_substring>\n\n"
  STDERR.puts 'Finds full title, pid, and window handle for windows matching'
  STDERR.puts 'the title substring. For titles with spaces, wrap in quotes.'
  exit 1
end

count = 0
Win32::Window.find(title: /#{title}/i).each do |window|
  next if window.title.match(this_file)
  puts if count > 0
  puts "title \"#{window.title}\""
  puts "pid #{window.pid}"
  puts format('appTopLevelWindow 0x%08x', window.handle)
  count += 1
end

if count.zero?
  STDERR.puts "NO WINDOWS FOUND: \"#{title}\""
  exit 1
end
