require 'rutl/interface/browser/browser'

module RUTL
  module Interface
    #
    # Interface-level code for fake application.
    #
    class Null < Browser
      def initialize
        context = RUTL::Element::ElementContext.new(destinations: nil,
                                                    interface: self,
                                                    selectors: [])
        @driver = NullDriver.new(context)
        super
      end

      # The null driver needs to talk to the null interface.
      # Other driver/interface relations are not like this.
      attr_writer :current_view

      def current_view
        # Default to @view.first if not set?
        # An application can always check its current URL but
        # the null driver can't.
        @current_view ||= @views.first
      end

      def wait_for_transition(destinations)
        # TODO: Setting @current view didn't do it beacause that set
        # context.interface.current_view and we wanted this in the application.
        @current_view = destinations.first.new(self)
        $application.current_view = @current_view
      end
    end
  end
end
