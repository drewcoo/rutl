require 'utilities'
require 'rutl/camera'

module RUTL
  module Interface
    #
    # I might need to consider renaming these.
    # The *interface classes lie between Browser
    # and the webdriver-level classes.
    #
    class Base
      include Utilities

      # RUTL::Driver
      attr_accessor :driver

      # RUTL::Camera
      attr_accessor :camera

      # Array of all RUTL::Page classes
      attr_accessor :pages

      def initialize
        raise 'Child interface class must set @driver.' if @driver.nil?
        # base_name avoids collisions when unning the same tests with
        # different browsers.
        name = self.class.to_s.sub('RUTL::Interface', '')
        @camera = Camera.new(@driver, base_name: name)
      end

      # Attempts to navigate to the page.
      # Takes screenshot if successful.
      def goto(page)
        raise 'expect Page class' unless page?(page)
        find_page(page).go_to_here
        @camera.screenshot
      end

      # Should define in children; raises here.
      # Should return the current page class.
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
          return page if page.loaded?
        end
        false
      end

      # Attempts to find page by class or url.
      def find_page(page)
        @pages.each do |p|
          return p if page?(page) && p.class == page
          return p if String == page.class && page == p.url
        end
        raise "Page \"#{page}\" not found in pages #{@pages}"
      end

      # Calls the polling utility mathod await() with a lambda trying to
      # find the next state, probably a Page class.
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
      end
    end
  end
end
