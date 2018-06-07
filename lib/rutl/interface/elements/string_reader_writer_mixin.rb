module RUTL
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
    # base element to do this_css calls. So I have to change the way
    # drivers are passed into everything or initially have them everywhere,
    # which means rewriting chosen drivers or changing page load.
    # Ick.
    def set(string)
      clear
      this_css.send_keys(string)
    end
    alias text= set
    alias value= set

    def get
      this_css.attribute(:value)
    end
    alias text get
    alias value get
    alias to_s get

    def clear
      this_css.clear
      get
    end

    def eql?(other)
      other == get
    end
    alias == eql?

    def send_keys(string)
      this_css.send_keys(string)
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
    # TODO: Fall through to String methods?
    #
  end
end
