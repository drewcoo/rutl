#
# This fakes all page elements when used with the null driver.
# It's a dirty way to avoid modeling all of what a driver talks to.
#
class NullDriverPageElement
  attr_accessor :string
  attr_reader :selector_type, :selector

  attr_accessor :interface
  attr_accessor :destinations

  def initialize(selector_type, selector)
    # :css, selector
    @selector_type = selector_type
    @selector = selector
  end

  def send_keys(string)
    @string = string
  end

  def attribute(attr)
    case attr.to_sym
    when :value
      @string
    else
      raise ArgumentError, "Attribute unknown: #{attr}"
    end
  end

  # Return simple strings for checks against the NullDriver instead of
  # having to use some heavyweight UI.
  def clear
    'clear'
  end

  def click
    'click'
  end
end
