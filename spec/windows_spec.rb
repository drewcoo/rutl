# Windows tests only run on Windows.
if ENV['OS'] == 'Windows_NT'

  require 'em/pure_ruby'
  require 'rubygems'
  require 'appium_lib'
  require 'rutl/appium/appium_extension'
  require 'rutl/appium/appium_server'
  require 'rutl/appium/windows_test_app_wrapper'
  require 'rspec'

  RSpec.describe 'windows tests' do
    before(:all) do
      @appium_server = AppiumServer.new
      @appium_server.start
    end

    after(:all) do
      @appium_server.stop
    end

    context 'with notepad' do
      let(:app) do
        RUTL::Application.new(family: :windows, type: :notepad,
                              views: 'spec/views/notepad')
      end

      after do
        app.quit
      end

      it 'types some text and clears and retypes' do
        string = 'hello'
        edit_text.set string
        edit_text.clear
        edit_text.set string
        expect(edit_text).to eq(string)
      end
    end

    context 'with my app' do
      let(:app) do
        RUTL::Application.new(family: :windows, type: :hello,
                              views: 'spec/views/hello')
      end

      after do
        app.quit
      end

      it 'can close app' do
        close_button.click
        expect(app.open?).to be false
      end

      it 'can close app with exit button' do
        exit_button.click
        expect(app.open?).to be false
      end
    end
  end
end
