require 'webdrivers' if ENV['CIRCLECI'].nil?
require 'spec_helper'
require 'rutl/interface/firefox_interface'

describe FirefoxInterface do
  let(:browser) do
    Browser.new(page_object_dir: page_object_dir, interface_type: :firefox)
  end

  before do
    browser.goto(InternetLoginPage)
  end

  context 'with text field' do
    it 'read/write' do
      username = 'foo'
      browser.username_text.set username
      expect(browser.username_text.get).to eq username
    end
  end
end
