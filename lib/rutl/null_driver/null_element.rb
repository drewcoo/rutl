require 'rutl/element/element_context'

module RUTL
  module Element
    #
    # This fakes all page elements when used with the null driver.
    # It's a dirty way to avoid modeling all of what a driver talks to.
    #
    class NullElement
      attr_accessor :context

      def self.clear_variables
        @@variables = {}
      end

      def initialize(context, _type, location)
        @@variables ||= {}
        @context = context
        @location = location
      end

      # @@string is a class variable because this framework creates new
      # instances of each element every time it accesses them. This is good
      # behavior by default because pages could change underneath us.
      # For text fields in the null browser, though, we want to preserve the
      # values across calls, letting us write and then read.
      def send_keys(string)
        init = @@variables[@location] || ''
        @@variables[@location] = init + string
      end

      def attribute(attr)
        case attr.to_sym
        when :value
          @@variables[@location] || ''
        else
          raise ArgumentError, "Attribute unknown: #{attr}"
        end
      end

      def clear
        @@variables[@location] = ''
      end

      def this_css
        self
      end

      # Placeholder - NOP
      # Called by RUTL::Element::ClickToChangeStateMixin like
      # Selenium driver.click
      def click; end
    end
  end
end
