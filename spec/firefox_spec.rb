require 'webdrivers'
require 'spec_helper'

describe 'LoginPageTest' do
  let(:browser) do
    Browser.new(page_object_dir: page_object_dir, interface_type: :firefox)
  end
  before(:each) do
    browser.goto(InternetLoginPage)
  end

  context 'text field' do
    it 'read/write' do
      username = 'foo'
      browser.username_text.set username
      expect(browser.username_text.get).to eq username
    end
  end
end
