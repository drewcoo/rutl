require 'rutl/interface/base_interface'

#
# Interface-level code for fake browser.
#
class NullInterface < BaseInterface
  @variables = []
  attr_accessor :variables

  def initialize(pages:)
    @driver = NullDriver.new
    @driver.interface = @interface
    super
  end

  def set_current_page(page)
    @current_page = page
  end

  def current_page
    # Default to @pages.first if not set?
    # A browser can alwasy check its current URL but the null driver can't.
    @current_page || @pages.first
  end

  def wait_for_transition(destinations)
    @current_page = find_page(destinations.first)
  end
end
