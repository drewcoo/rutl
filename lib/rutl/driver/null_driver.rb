require 'rutl/driver/null_driver_page_element'

module RUTL
  #
  # This is at a peer level to the webdrivers but it's for a fake brwoser.
  #
  class NullDriver
    attr_accessor :context

    def initialize(context)
      raise 'no context' unless context.is_a?(ElementContext)
      @context = context
    end

    def find_element(type, location)
      # Return a new one of these so that it can be clicked ar written
      # to or whatever.
      context = ElementContext.new(interface: @context.interface)
      NullDriverPageElement.new(context, type, location)
    end

    # Cheap way to handle browser.navigate.to(url)
    # TODO: Until I care about the url and then I should ????
    def navigate
      context = ElementContext.new(interface: @context.interface)
      NullDriver.new(context)
    end

    def to(url)
      result = @context.interface.find_page(url)
      @context.interface.current_page = result
      result.url
    end

    def quit
      # Clean out the @@variables.
      NullDriverPageElement.clear_variables
    end
  end
end
