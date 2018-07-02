# gem install win32-window --pre
require 'win32/window'
#
# wrapper for simple test apps
#
class WindowsTestApp
  attr_reader :window_handle_string

  def initialize(name:, title:)
    @name = name
    @title = title
  end

  def wait_for_started
    # Put this on a timeout!
    app_windows = []
    until(app_windows.size > 0)
      app_windows = Win32::Window.find(title: @title)
      raise 'found more than one instance of app' if app_windows.size > 1
      sleep 0.1
    end
    @pid = app_windows.first.pid
    @window_handle_string = "0x%08x" % app_windows.first.handle
  end

  def start
    quiet_cmd "start \"NO TITLE\" \"#{@name}\""
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
