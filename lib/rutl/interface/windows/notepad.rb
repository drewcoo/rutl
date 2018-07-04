require 'selenium-webdriver'
require 'rutl/interface/windows/windows_app'

module RUTL
  module Interface
    #
    # Notepad.
    #
    class Notepad < WindowsApp
      def initialize
        puts 'new notepad !!!'
        @app_name = 'notepad.exe'
        driver_opts = base_opts
        puts 'did the opts thing'
        driver_opts[:caps][:app] = 'C:\Windows\System32\notepad.exe'
        puts 'notepad:'
        system 'dir c:\windows\system32\notepad*'
        puts 'appium start this thing'
        @driver = Appium::Driver.new(driver_opts, false)
        puts 'new the thing to start'
        @driver.start
        puts 'ok, notepad finally started'
        super
      end

      def current_view
        # This only works because I only have one view.
        # Should I? What about dialogs?
        @views.first
      end
    end
  end
end
