#
# Mix this in for things that change state when clicked.
# The only things that wouldn't change state when clicked either
# shouldn't be clicked or are just annoying.
#
module ClickToChangeStateMixin
  def click
    # Screenshot before clicking. Is this really necessary?
    @context.interface.camera.screenshot
    this_css.click
    # returns the page it found
    result = @context.interface.wait_for_transition(@context.destinations)
    # And after clicking and going to new state. This seems more needed
    # because we want to see where we went.
    @context.interface.camera.screenshot
    result
  end
end
