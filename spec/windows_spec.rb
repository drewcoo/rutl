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
  main_pane = { xpath: '/Window/Edit' }
  file_menu = { name: 'File' }
  file_menu_new = { name: 'New' }
  file_menu_open = { name: 'Open...' }
  help_menu = { name: 'Help' }
  help_menu_about = { name: 'About Notepad' }
  about_dialog = { name: 'About Notepad' }
  about_dialog_ok = { name: 'OK' }
  close_button = { name: 'Close' }
  dialog_dont_save = { xpath: '/Window/Window/Button[2]' }

  hello_exit_button = { xpath: '/Window/Pane/Button' }
  #
  # Dumb method to return a hash that ought to be frozen but that's
  # not really a Ruby thing despite all of Rubocop's complaints about strings.
  #
  def base_opts
    { caps: { platformName: "WINDOWS",
              platform: "WINDOWS",
              deviceName: "WindowsPC" },
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
      before(:each) do
        driver_opts = base_opts
        driver_opts[:caps][:app] = 'C:\Windows\System32\notepad.exe'
        @driver = Appium::Driver.new(driver_opts, false)
        #   Appium.promote_appium_methods RSpec::Core::ExampleGroup
        # I think I prefer only handing driver this way and that works
        # best in let.
        @driver.start
      end

      after(:each) do
        @driver.find_element(close_button).click
        @driver.find_element(dialog_dont_save).click
        @driver.driver_quit
      end

      it 'types some text and clears and retypes' do
        string = 'hello'
        pane = @driver.find_element(main_pane)
        # Need to change to this when using framework:
        #
        # pane = string
        # pane.clear
        # pane = string
        # expect(pane).to eq(string)
        #
        pane.send_keys string
        pane.clear
        pane.send_keys string
        expect(pane.attribute(:value) || pane.text).to eq(string)
      end
    end

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
  end
end
