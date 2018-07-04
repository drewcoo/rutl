module Appium
  ##
  # Extend Appium because I keep digging through WinAppDriver junk to
  # figure out what's broken.
  #
  class Driver
    def start
      start_driver
    rescue RuntimeError => e
      if e.cause.to_s =~ /Failed to open TCP connection/
        puts 'Cannot reach Appium server. Is it running? On the right port?'
      else
        puts "Cannot diagnose:\n#{e}"
      end
      exit
    rescue Selenium::WebDriver::Error::NoSuchWindowError => e
      puts "\n\n" + e.class
      puts "\n\n" + e.cause
      puts "\n\n" + e.backtrace
      puts "\n\n" + (e.methods - Class.methods)
    end

    def app_open?
      find_elements(:id, 0)
      true
    rescue Selenium::WebDriver::Error::NoSuchWindowError
      false
    end

    def quit
      driver_quit
    end
  end
end
