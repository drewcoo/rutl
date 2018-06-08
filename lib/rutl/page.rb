require 'rutl/element'
require 'rutl/null_driver/null_driver'

module RUTL
  #
  # Base page class. It's used to call the magical method_messing
  # stuff to parse the page object files into actual objects.
  #
  class Page
    # BUGBUG: Kludgy. What do I really want to do here?
    # Make it easy to define a page's default url and
    # also matchers for page urls for pages with variable urls?
    # rubocop:disable Style/TrivialAccessors
    def self.url
      @url
    end

    def url
      self.class.url
    end
    # rubocop:enable Style/TrivialAccessors

    # Intentially use a class variable to hald pages. Once they're all loaded
    # they are all loaded for everyone.
    # rubocop:disable Style/ClassVars
    @@loaded_pages = []
    # rubocop:enable Style/ClassVars

    def initialize(interface)
      @interface = interface
      # Dirty trick because we're loading all of page classes from files and
      # then initializing them, calling their layout methods to do magic.
      # The Page class knows what pages are loaded.
      return if @@loaded_pages.include?(self.class)
      layout
      @@loaded_pages << self.class
    end

    def go_to_here
      # Ovveride this in base page to have something more
      # complicated than this.
      @interface.driver.navigate.to(url)
    end

    # Written by Browser and only used internally.
    attr_writer :interface

    def loaded?
      url == @interface.driver.current_url
    end

    # Dynamically add a method, :<name> (or :<name>= if setter)
    # to the current class where that method creates an instance
    # of klass.
    # context is a RUTL::Element::ElementContext
    #
    # As it is, this seems silly to break into pieces for Rubocop.
    # rubocop:disable Metrics/MethodLength
    def add_method(context:, klass:, name:, setter: false)
      name = "#{name}_#{klass.downcase}"
      constant = Module.const_get("RUTL::Element::#{klass.capitalize}")
      self.class.class_exec do
        if setter
          define_method("#{name}=") do |value|
            constant.new(context, value)
          end
        else
          define_method(name) do
            constant.new(context)
          end
        end
      end
    end
    private :add_method
    # rubocop:enable Metrics/MethodLength

    # This creates a new element instance whenever it's called.
    # Because of that we can't keep state in any element objects.
    # That seems like a good thing, actually.
    # Called by layout method on pages.
    #
    # Hard to make shorter.
    # rubocop:disable Metrics/MethodLength
    def method_missing(element, *args, &_block)
      name, selectors, rest = args
      context = RUTL::Element::ElementContext.new(destinations: rest,
                                   interface: @interface,
                                   selectors: selectors)
      case element
      when /button/, /checkbox/, /element/, /link/
        add_method(name: name, context: context, klass: element)
      when /text/
        add_method(name: name, context: context, klass: element)
        add_method(name: name, context: context, klass: element, setter: true)
      else
        # TODO: replace with a super call. This is useful for debugging for now.
        raise "#{element} NOT FOUND WITH ARGS #{args}!!!"
      end
    end
    # rubocop:enable Metrics/MethodLength

    def respond_to_missing?(*args)
      # Is this right at all???
      case args[0].to_s
      when /button/, /checkbox/, /element/, /link/, /text/,
           'driver', 'url', 'children', 'loaded?'
        true
      when 'ok_link'
        raise 'OK LINK WAY DOWN HERE IN BASE PAGE!!!'
      else
        # I think it's good to raise but change the message.
        raise 'TODO: BETTER ERROR MESSAGE, PLEASE. I AM SHOUTING!!!\n' \
              'Drew, you hit this most often when checking current page ' \
              "rather than current page class:\n\n #{args}"
        # I think I want to raise instead of returningn false.
      end
    end
  end
end
