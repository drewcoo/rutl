require 'webdrivers' if ENV['CIRCLECI'].nil?
require 'spec_helper'
require 'rutl/interface/chrome_interface'

RSpec.describe ChromeInterface, :slow do
  let!(:browser) do
    Browser.new(type: :chrome)
  end

  before do
    goto(InternetLoginPage)
  end

  context 'with text field' do
    it 'read/write' do
      username = 'foo'
      username_text = username
      expect(username_text).to eq username
    end

    it 'clear' do
      username = 'foo'
      username_text = username
      username_text.clear
      expect(username_text).to eq ''
    end
  end

  context 'with password field' do
    it 'read' do
      username = 'foo'
      username_text = username
      expect(username_text).to eq username
    end
  end

  context 'when log in' do
    before do
      username = 'tomsmith'
      password = 'SuperSecretPassword!'
      browser.username_text = username
      browser.password_text = password
    end

    it 'lands on logged in page' do
      login_button.click
      expect(current_page).to be_page(InternetLoggedInPage)
    end

    it 'can log back out' do
      login_button.click
      logout_button.click
      expect(current_page.url).to eq 'http://the-internet.herokuapp.com/login'
    end
  end
end
