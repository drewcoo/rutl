require 'rutl/interface/elements/base_element'
require 'rutl/interface/elements/click_to_change_state_mixin'

#
# It's a button!
#
class Button < BaseElement
  include ClickToChangeStateMixin
  # def get, text - return button text; useful for text-changing buttons
end
