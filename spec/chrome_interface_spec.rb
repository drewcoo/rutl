require 'webdrivers' if ENV['CIRCLECI'].nil?
require 'spec_helper'
require 'rutl/interface/chrome_interface'

RSpec.describe ChromeInterface do
  let(:browser) do
    Browser.new(page_object_dir: page_object_dir, interface_type: :chrome)
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

    it 'clear' do
      username = 'foo'
      browser.username_text.set username
      browser.username_text.clear
      expect(browser.username_text.get).to eq ''
    end
  end

  context 'with password field' do
    it 'read' do
      username = 'foo'
      browser.username_text.set username
      expect(browser.username_text.get).to eq username
    end
  end

  context 'when log in' do
    before do
      username = 'tomsmith'
      password = 'SuperSecretPassword!'
      browser.username_text.set username
      browser.password_text.set password
    end

    it 'lands on logged in page' do
      browser.login_button.click
      expect(browser.current_page.class).to eq InternetLoggedInPage
    end

    it 'can log back out' do
      browser.login_button.click
      browser.logout_button.click
      expect(browser.current_url).to eq 'http://the-internet.herokuapp.com/login'
    end
  end
end
