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
  def self.url; @url; end

  def url; self.class.url; end

  @@children = []
  def self.children; @@children; end

  attr_accessor :driver

  # TODO: DO I REALLY WANT TO PASS IN DRIVER LIKE THAT?
  def initialize
    # Call a class's layout method the first time it's loaded
    # and put the class name in a list of children, which is a
    # list of all actual page objects in this case.
    return if @@children.include?(self.class)
    layout
    @@children << self.class
  end

  def loaded?
    @url = @driver.current_url
  end

  # BUGBUG: This creates a new element instance whenever it's called.
  # Because of that we can't keep state in any element objects.
  # Is that actually a good thing, maybe?

  # Called by layout method on pages.
  def method_missing(element, *args, &_block)
    name, selector, rest = args
    name = "#{name}_#{element.downcase}"

    case element
    when /button/, /checkbox/, /link/
      # self.class.class_exec do
      #   define_method(name) do
      #     Module.const_get(element.capitalize).new(selector, rest)
      #   end
      # end
      self.class.class_exec do
        foo = Module.const_get(element.capitalize).new(selector, rest)
        define_method(name) do
          foo
        end
      end
    when /text/
      self.class.class_exec do
        # foo = Module.const_get(element.capitalize).new(selector, rest)
        # define_method("_#{name}") do
        #   foo.get
        # end
        define_method(name) do
          Module.const_get(element.capitalize).new(selector, rest)
        end
        # define_method(name.to_s) do
        #   foo.get
        # end
        # define_method((name + '=').to_s) do
        #   foo.set
        # end
        # foo.define_method(:get) do
        #   foo.get
        # end
        # foo.define_method(:set) do
        #   foo.set
        # end
      end
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
            'rather than current page class'
      # I think I want to raise instead of returningn false.
    end
  end
end
