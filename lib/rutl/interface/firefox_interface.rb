require 'selenium-webdriver'
require 'rutl/interface/base_interface'

#
# Small interface for Chrome browser.
#
class FirefoxInterface < BaseInterface
  def initialize
    @logged_in = true
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    options.add_argument('--headless') if ENV['TRAVIS'] == 'true'
    @driver = Selenium::WebDriver.for :firefox, options: options
    super
  end

  def current_page
    url = @driver.current_url
    page = find_page(url)
    raise "PAGE NOT FOUND: #{url}, PAGES: #{@pages}" unless page
    page
  end
end
