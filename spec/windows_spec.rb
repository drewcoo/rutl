# Windows tests only run on Windows.
# And they don't run on Appveyor so I have to figure that out, too.
if ENV['OS'] == 'Windows_NT' && ENV['COMPUTERNAME'] == 'DREW-DEV2'

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

  #
  # Dumb method to return a hash that ought to be frozen but that's
  # not really a Ruby thing despite all of Rubocop's complaints about strings.
  #
  def base_opts
    { caps: { platformName: 'WINDOWS',
              platform: 'WINDOWS',
              deviceName: 'WindowsPC' },
      appium_lib: { wait_timeout: 2,
                    wait_interval: 0.01 } }
  end

  RSpec.describe 'windows tests' do
    before(:all) do
      @appium_server = AppiumServer.new
      @appium_server.start
    end

    after(:all) do
      @appium_server.stop
    end

    context 'with notepad' do
      let!(:application) do
        RUTL::Application.new(type: :notepad, rutl_views: 'spec/views/notepad')
      end

      after do
        application.quit
      end

      it 'types some text and clears and retypes' do
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
