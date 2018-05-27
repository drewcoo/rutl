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

  # The null driver needs to talk to the null interface.
  # Other driver/interface relations are not like this.
  attr_writer :current_page

  def current_page
    # Default to @pages.first if not set?
    # A browser can alwasy check its current URL but the null driver can't.
    @current_page || @pages.first
  end

  def wait_for_transition(destinations)
    @current_page = find_page(destinations.first)
  end
end
