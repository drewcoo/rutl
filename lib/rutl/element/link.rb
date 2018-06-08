require 'rutl/element/element'
require 'rutl/element/click_to_change_state_mixin'

module RUTL
  module Element
    #
    # Link, of course.
    #
    class Link < Element
      include ClickToChangeStateMixin
      # text, url - get what they say
      # should there be a 'get' - what would it get?
    end
  end
end
