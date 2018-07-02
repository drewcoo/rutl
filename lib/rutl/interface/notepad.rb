require 'selenium-webdriver'
require 'rutl/interface/base'

module RUTL
  module Interface
    #
    # Small interface for Chrome browser.
    #
    class Notepad < Base
      def base_opts
        { caps: { platformName: 'WINDOWS',
                  platform: 'WINDOWS',
                  deviceName: 'WindowsPC' },
          appium_lib: { wait_timeout: 2,
                        wait_interval: 0.01 } }
      end

      def initialize
        driver_opts = base_opts
        driver_opts[:caps][:app] = 'C:\Windows\System32\notepad.exe'
        @driver = Appium::Driver.new(driver_opts, false)
        #   Appium.promote_appium_methods RSpec::Core::ExampleGroup
        # I think I prefer only handing driver this way and that works
        # best in let.
        @driver.start
        super
      end

      def current_view
        # This only works because I only have one view.
        # Should I? What about dialogs?
        @views.first
      end

      def kill
        system 'taskkill /f /im notepad.exe /t 1>nul 2>&1'
      end

      def quit
        kill
        @driver.driver_quit
      end
    end
  end
end
