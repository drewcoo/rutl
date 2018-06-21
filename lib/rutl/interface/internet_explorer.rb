require 'selenium-webdriver'
require 'rutl/interface/base'

module RUTL
  module Interface
    #
    # Small interface for Chrome browser.
    #
    class InternetExplorer < Base
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

      def current_page
        url = @driver.current_url
        page = find_page(url)
        raise "PAGE NOT FOUND: #{url}, PAGES: #{@pages}" unless page
        page
      end
    end
  end
end
