require 'selenium-webdriver'
require 'rutl/interface/browser/browser'

module RUTL
  module Interface
    #
    # Small interface for Chrome browser.
    #
    class InternetExplorer < Browser
      def initialize
        @logged_in = true
        options = Selenium::WebDriver::IE::Options.new
        options.add_argument('--ignore-certificate-errors')
        options.add_argument('--disable-popup-blocking')
        options.add_argument('--disable-translate')
        options.ignore_zoom_level = true
        options.initial_browser_url = 'https://www.google.com/'
        @driver = Selenium::WebDriver.for :internet_explorer, options: options
        super
      end
    end
  end
end
