require 'win32/window'
require 'utilities/waiter'
#
# wrapper for simple test apps
#
class WindowsTestApp
  include Waiter
  attr_reader :window_handle_string

  def initialize(name:, title:)
    @name = name
    @title = title
  end

  def find_window_by_title
    system('tasklist /fi "windowtitle eq Hello World"')
    result = Win32::Window.find(title: @title)
    raise 'found more than one instance of app' if result.size > 1
    result.empty? ? false : result.first
  end

  def wait_for_started
    app_window = await -> { find_window_by_title }
    @pid = app_window.pid
    @window_handle_string = format('0x%08x', app_window.handle)
  end

  def start
    puts 'STARTING!!!'
    str = "start \"NO TITLE\" #{@name}"
    puts str
    system str
    wait_for_started
  end

  def stop
    quiet_cmd "taskkill /f /pid #{@pid} /t"
  end
  alias kill stop

  def quiet_cmd(in_string)
    system in_string + ' 1>nul 2>&1'
  end
end
