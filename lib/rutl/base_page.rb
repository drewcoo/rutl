require 'rutl/interface/elements'
require 'rutl/driver/null_driver'

#
# Base page class. It's used to call the magical method_messing
# stuff to parse the page object files into actual objects.
#
class BasePage
  # BUGBUG: Kludgy. What do I really want to do here?
  # Make it easy to define a page's default url and
  # also matchers for page urls for pages with variable urls?
  def self.url
    @url
  end

  def url
    self.class.url
  end

  @@loaded_pages = []

  def initialize(interface)
    @interface = interface
    # Dirty trick because we're loading all of page classes from files and then
    # initializing them, calling their layout methods to do magic.
    # The base_page class knows what pages are loaded.
    return if @@loaded_pages.include?(self.class)
    layout
    @@loaded_pages << self.class
  end

  # Written by Browser and only used internally.
  attr_writer :interface

  def loaded?(driver)
    url == driver.current_url
  end

  # Dynamically add a method, :<name> (or :<name>= if setter)
  # to the current class where that method creates an instance
  # of klass.
  # context is an ElementContext
  def add_method(context:, klass:, name:, setter: false)
    name = "#{name}_#{klass.downcase}"
    constant = Module.const_get(klass.capitalize)
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

  # This creates a new element instance whenever it's called.
  # Because of that we can't keep state in any element objects.
  # That seems like a good thing, actually.
  # Called by layout method on pages.
  def method_missing(element, *args, &_block)
    name, selectors, rest = args
    context = ElementContext.new(destinations: rest,
                                 interface: @interface,
                                 selectors: selectors)
    case element
    when /button/, /checkbox/, /link/
      add_method(name: name, context: context, klass: element)
    when /text/
      add_method(name: name, context: context, klass: element)
      add_method(name: name, context: context, klass: element, setter: true)
    else
      # TODO: replace with a super call. This is useful for debugging for now.
      raise "#{element} NOT FOUND WITH ARGS #{args}!!!"
    end
  end

  def respond_to_missing?(*args)
    # Is this right at all???
    case args[0].to_s
    when /button/, /checkbox/, /link/, /text/,
         'driver', 'url', 'children', 'loaded?'
      true
    when 'ok_link'
      raise 'OK LINK WAY DOWN HERE IN BASE PAGE!!!'
    else
      # I think it's good to raise but change the message.
      raise 'Drew, you hit this most often when checking current page ' \
            "rather than current page class:\n\n #{args}"
      # I think I want to raise instead of returningn false.
    end
  end
end
