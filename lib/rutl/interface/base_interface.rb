require 'rutl/utilities'

#
# I might need to consider renaming these.
# The *interface classes lie between Browser and the webdriver-level classes.
#
class BaseInterface
  include Utilities

  def current_url
    current_page.url
  end

  attr_reader :pages

  # Child classes must implement current_page

  attr_accessor :driver

  attr_accessor :interface

  def initialize(pages:)
    @pages = pages
    raise 'Child classes must implement @driver.' unless defined? @driver
    @pages.each { |p| p.driver = @driver }
  end

  def goto(input)
    # TODO: KLUDGY. Fix. Modifier if usage bombs here. *shrug*
    @driver.interface = @interface if 'NullInterface' == @interface.class.to_s
    input = find_page(input) unless input.methods.include?(:url)

    @driver.navigate.to input.url
  end

  def current_page
    raise 'OVERRIDE IN CHILDREN'
  end

  def method_missing(method, *args, &block)
    result = if args.empty?
               current_page.send(method)
             else
               current_page.send(method, *args, &block)
             end
    raise interface.to_s if interface.nil?
    raise result.to_s unless defined? result # result.interface
    begin
      result.interface = interface
    rescue NoMethodError
      raise NoMethodError, "METHOD NOT FOUND: #{method}"
    end
    result
  end

  # TODO: Is this needed? I not only find the page but also make sure the
  # urls match. Even though that's what finding pages means?
  def find_state(target_states)
    target_states.each do |state|
      next unless state.url == current_page.url
      page = find_page(state, true)
      return current_page = page if page.loaded?
    end
    raise current_page.to_s if current_page.class == InternetLoggedInPage
    false
  end

  def find_page(page, raise_on_fail = false)
    @pages.each do |p|
      # page is a Page class
      return p if page?(page) && p.class == page
      # or a String, possibly URL
      return p if String == page.class && page == p.url
    end
    raise "Page \"#{page}\" not found in pages #{@pages}" if raise_on_fail
  end

  def wait_for_transition(target_states)
    #
    # TODO: Should also see if there are other things to wait for.
    # I don't think this is doing page load time.
    #
    await -> { find_state target_states }
  end

  def respond_to_missing?(*args)
    # This can't be right. Figure it out later.
    current_page.respond_to?(*args)
  end

  def quit
    @driver.quit
    @pages = []
  end
end
