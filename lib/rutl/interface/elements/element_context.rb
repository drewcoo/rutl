#
# The context passed around to all elements.
# What they need to know outside of themselves to function.
#
class ElementContext
  attr_accessor :destinations
  attr_accessor :interface
  attr_accessor :selectors

  def initialize(destinations: nil, interface: nil, selectors: [])
    unless destinations.nil? || destinations.class == Array
      # Should check each destination to make sure it's a Page or a _____, too.
      raise 'destination must be an Array of destinations or nil.'
    end
    @destinations = destinations || []
    unless interface.nil? || interface.class.ancestors.include?(BaseInterface)
      raise "#{interface.class}: #{interface} must be a *Interface class."
    end
    @interface = interface
    @selectors = selectors
  end

  def find_element(type)
    # @interface.driver.find_element(type, @selectors[type])
    # Should be this, but apparently @interface.driver is being overwritten
    # (or not written to) and it doesn't work. Using $browser does. :-(
    $browser.interface.driver.find_element(type, @selectors[type])
  end
end
