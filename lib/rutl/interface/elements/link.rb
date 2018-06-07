require 'rutl/interface/elements/element'
require 'rutl/interface/elements/click_to_change_state_mixin'

#
# Link, of course.
#
class Link < Element
  include ClickToChangeStateMixin
  # text, url - get what they say
  # should there be a 'get' - what would it get?
end
