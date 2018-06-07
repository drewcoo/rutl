module RUTL
  #
  # Page elements. Base class.
  #
  class Element
    attr_accessor :context

    def initialize(element_context)
      raise element_context.to_s unless element_context.is_a? ElementContext
      @context = element_context
      # Not sure why, but I'm seeing Chrome fail becase the context interface
      # passed in isn't the same as the browser's interface.
      # This only happens with click test cases, before the click, and
      # only if that case isn't run first.
      # The context we're passed is also an instance from as ChromeInterface,
      # but a different instance.
      #
      # Here's the kludge workaround line:
      @context.interface = $browser.interface
    end

    def this_css
      @context.find_element(:css)
    end

    def exists?
      @context.find_element(:css)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end

    def method_missing(method, *args, &block)
      if args.empty?
        this_css.send(method)
      else
        this_css.send(method, *args, &block)
      end
    end

    def respond_to_missing?(*args)
      this_css.respond_to?(*args)
    end
  end
end
