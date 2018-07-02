require 'selenium-webdriver'
require 'rutl/interface/browser/browser'

module RUTL
  module Interface
    #
    # Small interface for Chrome browser.
    #
    class Firefox < Browser
      def initialize
        @logged_in = true
        options = Selenium::WebDriver::Firefox::Options.new
        options.add_argument('--ignore-certificate-errors')
        options.add_argument('--disable-popup-blocking')
        options.add_argument('--disable-translate')
        options.add_argument('--headless') if ENV['TRAVIS'] || ENV['CIRCLECI']
        @driver = Selenium::WebDriver.for :firefox, options: options
        super
      end
    end
  end
end
