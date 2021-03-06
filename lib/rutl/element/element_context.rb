module RUTL
  module Element
    #
    # The context passed around to all elements.
    # What they need to know outside of themselves to function.
    #
    class ElementContext
      # Nil. Or an Array. One would hope an Array of states.
      # But I'm not checking.
      attr_accessor :destinations
      # Nil. Or a RUTL::Interface::Base.
      attr_accessor :interface
      # An Arrray, maybe empty and maybe an array of selectors.
      # TODO: This should be a hash.
      attr_accessor :selectors

      def initialize(destinations: nil, interface: nil, selectors: [])
        unless destinations.nil? || destinations.class == Array
          # Should check each destination to make sure it's a
          # View or a _____, too.
          raise 'destination must be an Array of destinations or nil.'
        end
        @destinations = destinations || []
        unless interface.nil? || interface.is_a?(RUTL::Interface::Base)
          raise "#{interface.class}: #{interface} " \
                'must be an Interface::* class.'
        end
        @interface = interface
        @selectors = selectors
      end

      def find_element(type = nil)
        type ||= @selectors.first.first
        # @interface.driver.find_element(type, @selectors[type])
        # Should be this, but apparently @interface.driver is being overwritten
        # (or not written to) and it doesn't work. Using $application does. :-(
        $application.interface.driver.find_element(type, @selectors[type])
      end
    end
  end
end
