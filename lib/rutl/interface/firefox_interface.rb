require 'selenium-webdriver'
require 'rutl/interface/base_interface'

#
# Small interface for Chrome browser.
#
# TODO: Probably the current_page() implementation should move up to base.
#
class FirefoxInterface < BaseInterface
  def initialize(pages:)
    @logged_in = true
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    if 'true' == ENV['TRAVIS']
      options.add_argument('--headless')
    #end
    @driver = Selenium::WebDriver.for :firefox, options: options
    super
  end

  def current_page
    url = @driver.current_url
    page = find_page(url, true)
    raise "PAGE NOT FOUND: #{url}, PAGES: #{@pages}" unless page
    page
  end
end
