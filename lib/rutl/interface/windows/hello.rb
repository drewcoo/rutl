require 'selenium-webdriver'
require 'rutl/interface/windows/windows_app'

module RUTL
  module Interface
    #
    # Notepad.
    #
    class Hello < WindowsApp
      def file_name
        File.expand_path('../../../../spec/hello.rb', __dir__)
      end

      def initialize
        @app = WindowsTestApp.new(name: file_name,
                                  title: /hello world/i)
        @app.start
        driver_opts = base_opts
        # Have to start app then attach winappdriver because these both fail:
        # 1. passing hello.rb path as [:caps][:app]
        # 2. passing ruby.exe path as [:caps][:app] and passing hello.rb
        #    path as [:caps][:appArguments]
        driver_opts[:caps][:appTopLevelWindow] = @app.window_handle_string
        # This means that screenshotting is busted in winappdriver
        # for unkonwn reasons.
        @driver = Appium::Driver.new(driver_opts, false)
        @driver.start
        super
      end

      def current_view
        # This only works because I only have one view.
        # Should I? What about dialogs?
        @views.first
      end
    end
  end
end
