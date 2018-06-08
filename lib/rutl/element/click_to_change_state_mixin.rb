module RUTL
  module Element
    #
    # Mix this in for things that change state when clicked.
    # The only things that wouldn't change state when clicked either
    # shouldn't be clicked or are just annoying.
    #
    module ClickToChangeStateMixin
      # click does:
      # * Screenshot before clicking. Is this really necessary?
      # * Click.
      # * Waits for transition to post-click state. (Polls until one reached.)
      # * Screenshot again after the transition. This one is definitely needed.
      # * Returns the state we transitioned to.
      def click
        @context.interface.camera.screenshot
        this_css.click
        result = @context.interface.wait_for_transition(@context.destinations)
        @context.interface.camera.screenshot
        result
      end
    end
  end
end
