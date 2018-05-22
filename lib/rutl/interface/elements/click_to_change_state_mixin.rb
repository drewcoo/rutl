#
# Mix this in for things that change state when clicked.
# The only things that wouldn't change state when clicked either
# shouldn't be clicked or are just annoying.
#
module ClickToChangeStateMixin
  def click
    this_css.click
    interface.wait_for_transition(@destinations)
    # TODO: Return what?
    @destinations
  end
end
