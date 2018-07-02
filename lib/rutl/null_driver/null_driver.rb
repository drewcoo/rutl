require 'rutl/null_driver/null_element'

module RUTL
  #
  # This is at a peer level to the webdrivers but it's for a fake application.
  #
  class NullDriver
    attr_accessor :context

    def initialize(context)
      raise 'no context' unless context.is_a?(RUTL::Element::ElementContext)
      @context = context
    end

    # Return a new one of these fake things so that it can be clicked
    # ar written to or whatever.
    def find_element(type, location)
      context = RUTL::Element::ElementContext.new(interface: @context.interface)
      RUTL::Element::NullElement.new(context, type, location)
    end

    # Cheap way to handle application.navigate.to(url)
    # TODO: Until I care about the url and then I should ????
    def navigate
      context = RUTL::Element::ElementContext.new(interface: @context.interface)
      NullDriver.new(context)
    end

    # Cheap second part to naviate.to(url) calls to look like real drivers.
    def to(url)
      result = @context.interface.find_view(url)
      @context.interface.current_view = result
      result.url
    end

    # Clean out the @@variables from NullElement.
    # Other than this, this is a placeholder to match real drivers.
    def quit
      RUTL::Element::NullElement.clear_variables
    end
  end
end
