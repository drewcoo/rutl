module RUTL
  module Element
    #
    # Implement String stuff in a mixin.
    # TODO: Not finished yet. Must be able to
    #
    module StringReaderWriterMixin
      # Override BaseElement's normal initialize method.
      def initialize(element_context, input_value = nil)
        raise element_context.to_s unless element_context.is_a? ElementContext
        @context = element_context
        set input_value unless input_value.nil?
      end

      # I could cut set() and only foo_text= if I change this.
      # The problem I'm running into is not having the driver in
      # base element to do find_element calls. So I have to change the way
      # drivers are passed into everything or initially have them everywhere,
      # which means rewriting chosen drivers or changing view load.
      # Ick.
      def set(string)
        clear
        find_element.send_keys(string)
      end
      alias text= set
      alias value= set

      # Return the String held by this element.
      def get
        found = find_element
        # This is a clumsy workaround for winappdriver, which gets textfields
        # as #text even though everything else seems to use #attribute(:value).
        # If both are false, this is undefined.
        found.attribute(:value) || found.text
      end
      alias text get
      alias value get
      alias to_s get

      # Talk to the view  and set the element's string to ''.
      def clear
        find_element.clear
        get
      end

      # String value equals.
      def eql?(other)
        other == get
      end
      alias == eql?

      # Sends these keystrokes without clearing the field.
      # Returns the whole string in the field, including this input.
      def send_keys(string)
        find_element.send_keys(string)
        get
      end

      def method_missing(method, *args, &block)
        # RuboCop complains unless I fall back to super here
        # even though that's pretty meaningless. Oh, well, it's harmless.
        super unless get.respond_to?(method)
        if args.empty?
          get.send(method)
        else
          get.send(method, *args, &block)
        end
      end

      def respond_to_missing?(method, flag)
        get.respond_to?(method, flag)
      end

      #
      # TODO: Fall through to String methods? I already fall through to
      # Selenium's Element methods in the Element class, so . . .
      # it's complicated.
      #
    end
  end
end
