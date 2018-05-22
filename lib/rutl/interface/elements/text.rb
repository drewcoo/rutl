require 'rutl/interface/elements/base_element'

#
# I'm using the text element for all text-like things. Passowrds, too.
#
class Text < BaseElement
  def initialize(selectors = {}, destinations = [])
    super
  end

  def clear
    this_css.clear
  end

  def text
    get
  end

  def get
    this_css.attribute(:value)
  end

  def text=(string)
    set(string)
  end

  def set(string)
    this_css.send_keys(string)
  end
end
