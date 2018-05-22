require 'selenium-webdriver'
require 'rutl/interface/base_interface'

#
# Small interface for Chrome browser.
#
# TODO: Probably the current_page() implementation should move up to base.
#
class ChromeInterface < BaseInterface
  def initialize(pages:)
    @logged_in = true
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--ignore-certificate-errors')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--disable-translate')
    options.add_argument('--headless --disable-gpu')
    @driver = Selenium::WebDriver.for :chrome, options: options
    super
  end

  def current_page
    url = @driver.current_url
    page = find_page(url, true)
    raise "PAGE NOT FOUND: #{url}, PAGES: #{@pages}" unless page
    page
  end
end
