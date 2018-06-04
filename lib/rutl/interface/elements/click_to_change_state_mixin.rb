#
# Mix this in for things that change state when clicked.
# The only things that wouldn't change state when clicked either
# shouldn't be clicked or are just annoying.
#
module ClickToChangeStateMixin
  def click
    this_css.click

    # TODO: Is this part of the instance-stamping problem???
    # returns the page it found
    @context.interface.wait_for_transition(@context.destinations)
  end
end
