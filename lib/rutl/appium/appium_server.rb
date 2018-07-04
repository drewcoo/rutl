require 'faraday'
require 'utilities/waiter'
#
# Class to wrap Appium in a Rubyish way.
#
class AppiumServer
  include Waiter
  attr_accessor :port, :server

  def initialize(server: nil, port: nil)
    @server = server || 'localhost'
    @port = port || 4723
  end

  def quiet_cmd(in_string)
    system in_string + ' 1>nul 2>&1'
  end

  def start
    raise 'server already started' if started?
    #quiet_cmd('start "appium" cmd /c appium')
    system('start /b "appium" cmd /c appium')
    await -> { started? }
  end

  def started?
    Faraday.get("http://#{@server}:#{@port}/wd/hub/status")
    true
  rescue Faraday::ConnectionFailed
    false
  end

  def stop
    raise 'server not started' unless started?
    quiet_cmd('taskkill /f /fi "WINDOWTITLE eq appium" /t')
  end
end
