require 'rutl/interface/elements/element'
require 'rutl/interface/elements/click_to_change_state_mixin'

#
# It's a button!
#
class Button < Element
  include ClickToChangeStateMixin
  # def get, text - return button text; useful for text-changing buttons
end
