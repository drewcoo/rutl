require 'rutl/camera'
require 'utilities/check_view'
require 'utilities/waiter'

module RUTL
  module Interface
    #
    # I might need to consider renaming these.
    # The *interface classes lie between Application
    # and the webdriver-level classes.
    #
    class Base
      include CheckView
      include Waiter

      # RUTL::Driver
      attr_accessor :driver

      # RUTL::Camera
      attr_accessor :camera

      # Array of all RUTL::View classes
      attr_accessor :views

      def initialize
        raise 'Child interface class must set @driver.' if @driver.nil?
        # base_name avoids collisions when unning the same tests with
        # different applications
        name = self.class.to_s.sub('RUTL::Interface', '')
        @camera = Camera.new(@driver, base_name: name)
      end

      # Attempts to navigate to the view.
      # Takes screenshot if successful.
      def goto(view)
        raise 'expect View class' unless view?(view)
        find_view(view).go_to_here
        @camera.screenshot
      end

      # Should define in children; raises here.
      # Should return the current view class.
      def current_view
        raise 'define in child classes'
      end

      def method_missing(method, *args, &block)
        if args.empty?
          current_view.send(method)
        else
          current_view.send(method, *args, &block)
        end
      end

      # TODO: Is this needed? I not only find the view but also make sure the
      # urls match. Even though that's what finding views means?
      def find_state(target_states)
        target_states.each do |state|
          next unless state.url == current_view.url
          view = find_view(state)
          return view if view.loaded?
        end
        false
      end

      # Attempts to find view by class or url.
      def find_view(view)
        @views.each do |p|
          return p if view?(view) && p.class == view
          return p if String == view.class && view == p.url
        end
        raise "View \"#{view}\" not found in views #{@views}"
      end

      # Calls the polling utility mathod await() with a lambda trying to
      # find the next state, probably a View class.
      def wait_for_transition(target_states)
        #
        # TODO: Should also see if there are other things to wait for.
        # I don't think this is doing view load time.
        #
        await -> { find_state target_states }
      end

      def respond_to_missing?(*args)
        # This can't be right. Figure it out later.
        current_view.respond_to?(*args)
      end

      def quit
        @driver.quit
      end
    end
  end
end
