#
# Page elements. Base class.
#
class BaseElement
  attr_accessor :interface
  def driver
    @interface.driver
  end
  attr_accessor :selectors
  attr_accessor :destinations

  def initialize(selectors = {}, destinations = [])
    @selectors = selectors
    @destinations = destinations
  end

  def find_css(selectors)
    result = driver.find_element(:css, selectors[:css])
    return result unless NullDriver == result.class
    result.destinations = @destinations
    result.interface = @interface
    result
  end

  def this_css
    find_css(@selectors)
  end
end
