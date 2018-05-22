require 'spec_helper'

describe 'LoginPageTest' do
  let(:browser) do
    Browser.new(page_object_dir: page_object_dir, interface_type: :chrome)
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

    it 'clear' do
      username = 'foo'
      browser.username_text.set username
      browser.username_text.clear
      expect(browser.username_text.get).to eq ''
    end
  end

  context 'password field' do
    it 'read' do
      username = 'foo'
      browser.username_text.set username
      expect(browser.username_text.get).to eq username
    end
  end

  it 'log in' do
    username = 'tomsmith'
    password = 'SuperSecretPassword!'
    browser.username_text.set username
    expect(browser.username_text.get).to eq username
    browser.password_text.set password
    expect(browser.current_url).to eq 'http://the-internet.herokuapp.com/login'
    expect(browser.current_page.class).to eq InternetLoginPage
    browser.login_button.click
    expect(browser.current_page.class).to eq InternetLoggedInPage
    expect(browser.current_url).to eq 'http://the-internet.herokuapp.com/secure'
    browser.logout_button.click
    expect(browser.current_url).to eq 'http://the-internet.herokuapp.com/login'
  end
end
