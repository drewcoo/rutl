require 'rutl/element/element'
require 'rutl/element/click_to_change_state_mixin'

module RUTL
  module Element
    #
    # It's a button!
    #
    class Button < Element
      include ClickToChangeStateMixin
      # def get, text - return button text; useful for text-changing buttons
    end
  end
end
