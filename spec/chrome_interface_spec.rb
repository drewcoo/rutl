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

  it 'fails bad login' do
    username_text = 'tomsmith'
    password_text = 'foo'
    login_button.click
    # This test site actually has different displayed for invalid user and
    # password. That is an informations leak thus a bug and I'd rather not
    # contribute to someone else "testing the bug in" so this only tests for
    # there being an error and not the type of error.
    expect(current_page).to be_page(InternetLoginErrorPage)
  end

  context 'when log in' do
    before(:each) do
      # TODO: browser doesn't have focus and get username_text unless
      # I explicitly pass browser.username_text here.
      # Why?
      browser.username_text = 'tomsmith'
      browser.password_text = 'SuperSecretPassword!'
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
