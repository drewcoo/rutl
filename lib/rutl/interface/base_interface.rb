require 'rutl/utilities'

#
# I might need to consider renaming these.
# The *interface classes lie between Browser and the webdriver-level classes.
#
class BaseInterface
  include Utilities

  attr_accessor :driver
  attr_accessor :pages

  def initialize
    raise 'Child interface class must set @driver.' if @driver.nil?
  end

  def goto(page)
    raise 'expect Page class' unless page.ancestors.include?(BasePage)
    find_page(page).go_to_here
  end

  def current_page
    raise 'define in child classes'
  end

  def method_missing(method, *args, &block)
    if args.empty?
      current_page.send(method)
    else
      current_page.send(method, *args, &block)
    end
  end

  # TODO: Is this needed? I not only find the page but also make sure the
  # urls match. Even though that's what finding pages means?
  def find_state(target_states)
    target_states.each do |state|
      next unless state.url == current_page.url
      page = find_page(state)
      return page if page.loaded?(@driver)
    end
    false
  end

  def find_page(page)
    @pages.each do |p|
      return p if page?(page) && p.class == page
      return p if String == page.class && page == p.url
    end
    raise "Page \"#{page}\" not found in pages #{@pages}"
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
    # Maybe I'm reusing pages from @pages?
    # @pages = []
  end
end
