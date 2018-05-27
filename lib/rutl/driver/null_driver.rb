require 'rutl/driver/null_driver_page_element'

#
# This is at a peer level to the webdrivers but it's for a fake brwoser.
#
class NullDriver
  attr_accessor :interface

  def find_element(type, location)
    # Return a new one of these so that it can be clicked ar written
    # to or whatever.
    element = NullDriverPageElement.new(type, location)
    element.interface = @interface
    element
  end

  # Cheap way to handle browser.navigate.to(url)
  # TODO: Until I care about the url and then I should ????
  def navigate
    result = NullDriver.new
    result.interface = @interface
    result
  end

  def to(url)
    result = @interface.find_page(url)
    @interface.current_page = result
    result.url
  end

  def quit
    'quit'
  end
end
