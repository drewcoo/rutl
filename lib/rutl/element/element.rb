module RUTL
  module Element
    #
    # View element base class.
    #
    class Element
      attr_accessor :context

      def initialize(element_context)
        raise element_context.to_s unless element_context.is_a? ElementContext
        @context = element_context
        # Not sure why, but I'm seeing Chrome fail becase the context interface
        # passed in isn't the same as the application's interface.
        # This only happens with click test cases, before the click, and
        # only if that case isn't run first.
        # The context we're passed is also an instance from as
        # RUTL::Interface::Chrome, but a different instance.
        #
        # Here's the kludge workaround line:
        @context.interface = $application.interface
      end

      def find_element
        @context.find_element
      end

      # Returns boolean, of course.
      # Unlike the underlying Selenium library, I have .exists? because I may
      # have a valid Element object for something that doesn't exist. Anymore.
      # Or yet.
      def exists?
        find_element
      rescue Selenium::WebDriver::Error::NoSuchElementError
        false
      end

      def method_missing(method, *args, &block)
        if args.empty?
          find_element.send(method)
        else
          find_element.send(method, *args, &block)
        end
      end

      def respond_to_missing?(*args)
        find_element.respond_to?(*args)
      end
    end
  end
end
