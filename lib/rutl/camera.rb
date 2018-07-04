require 'fileutils'

module RUTL
  #
  #   class to take photos of the screen (and diff them?)
  #
  class Camera
    def guard
      # When running headless, Selenium seems not to drop screenshots.
      # So that makes this safe in places like Travis.
      #
      # We still need to guard against NullDriver or we'll to to screencap
      # it when we're running head-fully.
      #
      # Will there be others?
      @driver.is_a? RUTL::NullDriver
    end

    def initialize(driver, base_name: '')
      @counter = 0
      @driver = driver
      return if guard
      @base_name = base_name.sub('::', '')
      @dir = File.join(RUTL::SCREENSHOTS, @base_name)
      FileUtils.mkdir_p @dir
    end

    def shoot(path = nil)
      return if guard
      # Magic path is used for all auto-screenshots.
      name = path || magic_path

      FileUtils.mkdir_p @dir
      file = File.join(@dir, pathify(name))
      if @driver.respond_to?(:save_screenshot)
        @driver.save_screenshot(file)
      else
        puts "WinAppDriver doesn't screenshot when attaching to existing apps."
      end
    end
    alias screenshot shoot

    def clean_dir(dir)
      FileUtils.rm_rf dir
      FileUtils.mkdir_p dir
    end

    def counter
      @counter += 1
      # In the unlikely even that we have > 9 screenshots in a test case,
      # format the counter to be two digits, zero padded.
      format('%02d', @counter)
    end

    def magic_path
      if defined? RSpec
        RSpec.current_example.metadata[:full_description].to_s
      else
        # TODO: The behavior for non-RSpec users is ugly and broken.
        # Each new test case will start taking numbered "auto-screenshot" pngs.
        # And the next test case will overwrite them. Even if they didn't
        # overwrite, I don't know how to correllate tests w/ scrrenshots. I'm
        # leaving this broken for now.
        # You can still tell it to take your own named screenshots whenever you
        # like, of course.
        'auto-screenshot'
      end
    end

    def pathify(path)
      # Replace any of these with an underscore:
      # space, octothorpe, slash, backslash, colon, period
      name = path.gsub(%r{[ \#\/\\\:\.]}, '_')
      # Also insert a counter and make sure we end with .png.
      name.sub(/.png$/, '') + '_' + counter + '.png'
    end
  end
end
