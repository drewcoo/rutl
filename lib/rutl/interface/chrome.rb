require 'selenium-webdriver'
require 'rutl/interface/base'

module RUTL
  module Interface
    #
    # Small interface for Chrome browser.
    #
    class Chrome < Base
      # rubocop:disable Metrics/MethodLength
      def initialize
        @logged_in = true
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--ignore-certificate-errors')
        options.add_argument('--disable-popup-blocking')
        options.add_argument('--disable-translate')
        # Run headless on TravisCI
        if ENV['TRAVIS']
          options.add_argument('--disable-gpu')
          options.add_argument('--headless ')
          options.add_argument('--no-sandbox')
        end
        @driver = Selenium::WebDriver.for :chrome, options: options
        super
      end
      # rubocop:enable Metrics/MethodLength

      def current_view
        url = @driver.current_url
        view = find_view(url)
        raise "NOT FOUND: #{url}, VIEWS: #{@views}" unless view
        view
      end
    end
  end
end
