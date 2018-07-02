##
# Extend Appium because I keep digging through WinAppDriver junk to
# figure out what's broken.
#
module Appium
  class Driver
    def start
      start_driver
    rescue RuntimeError => e
      # puts "YES, RUNTIME ERROR" if e.is_a? RuntimeError
      if e.cause.to_s =~ /Failed to open TCP connection/
        puts 'Cannot reach Appium server. Is it running? On the right port?'
      else
        puts "Cannot diagnose:\n#{e}"
      end
      exit
    rescue Selenium::WebDriver::Error::NoSuchWindowError => e
      puts e.class
      puts
      puts e.cause
      puts
      puts e.backtrace
      puts
      puts (e.methods - Class.methods)
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
