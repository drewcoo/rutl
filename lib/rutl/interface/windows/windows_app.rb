require 'selenium-webdriver'
require 'rutl/interface/base'

module RUTL
  module Interface
    #
    # Parent class for all Windows apps.
    #
    class WindowsApp < Base
      def base_opts
        { caps: { platformName: 'WINDOWS',
                  platform: 'WINDOWS',
                  deviceName: 'WindowsPC' },
          appium_lib: { wait_timeout: 2,
                        wait_interval: 0.01 } }
      end

      def kill
        system "taskkill /f /im #{@app_name} /t 1>nul 2>&1"
      end

      def open?
        @driver.find_elements(:id, 0)
        true
      rescue Selenium::WebDriver::Error::NoSuchWindowError
        false
      end

      def quit
        @driver.driver_quit
        kill
      end
    end
  end
end
