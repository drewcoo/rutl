# Windows tests only run on Windows.
if ENV['OS'] == 'Windows_NT'

  require 'em/pure_ruby'
  require 'rubygems'
  require 'appium_lib'
  require 'rutl/appium/appium_extension'
  require 'rutl/appium/appium_server'
  require 'rutl/appium/windows_test_app_wrapper'
  require 'rspec'

  #
  # view elements
  #
  hello_exit_button = { xpath: '/Window/Pane/Button' }

  RSpec.describe 'windows tests' do
    before(:all) do
      puts 'starting appium'
      @appium_server = AppiumServer.new
      @appium_server.start
      puts 'appium started'
    end

    after(:all) do
      @appium_server.stop
    end

    context 'with notepad' do
      let!(:app) do
        RUTL::Application.new(family: :windows, type: :notepad,
                              views: 'spec/views/notepad')
      end

      after do
        app.quit
      end

#Focus on this to get it working on AppVeyor
      fit 'types some text and clears and retypes' do
        string = 'hello'
        edit_text.set string
        edit_text.clear
        edit_text.set string
        expect(edit_text).to eq(string)
      end
    end
=begin
    context 'with my app' do
      before(:each) do
        @app = WindowsTestApp.new(name: 'c:\src\rutl\spec\hello.rb',
                                  title: /hello world/i)
        @app.start
        driver_opts = base_opts
        driver_opts[:caps][:appTopLevelWindow] = @app.window_handle_string
        @driver = Appium::Driver.new(driver_opts, false)
        @driver.start
      end

      after(:each) do
        @app.kill
        @driver.driver_quit
      end

      it 'can close app' do
        # close_button.click
        # #
        # # I'd really like this to look more like:
        # #   expect(app).to be_closed
        # # but what is "app" in that instance?
        # # Doing it right seems heavy-handed.
        # #
        # expect(app_open?).to be false
        @driver.find_element(name: 'Close').click
        expect(@driver.app_open?).to be false
      end

      it 'can close app with exit button' do
        # main_close_button.click
        # expect(app_open?).to be false
        @driver.find_element(hello_exit_button).click
        expect(@driver.app_open?).to be false
      end
    end
=end
  end
end
