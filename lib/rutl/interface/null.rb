require 'rutl/interface/base'

module RUTL
  module Interface
    #
    # Interface-level code for fake browser.
    #
    class Null < Base
      def initialize
        context = RUTL::Element::ElementContext.new(destinations: nil,
                                                    interface: self,
                                                    selectors: [])
        @driver = NullDriver.new(context)
        super
      end

      # The null driver needs to talk to the null interface.
      # Other driver/interface relations are not like this.
      attr_writer :current_page

      def current_page
        # Default to @pages.first if not set?
        # A browser can always check its current URL but the null driver can't.
        @current_page ||= @pages.first
      end

      def wait_for_transition(destinations)
        # TODO: Setting @current page didn't do it beacause that set
        # context.interface.current_page and we wanted this in the browser.
        @current_page = destinations.first.new(self)
        $browser.current_page = @current_page
      end
    end
  end
end
