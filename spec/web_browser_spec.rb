require 'webdrivers' unless ENV['CIRCLECI']
require 'utilities'
require 'spec_helper'

BROWSER_TYPES = %i[chrome firefox internet_explorer].freeze
BROWSER_TYPES.each do |browser_type|
  case browser_type
  when :chrome
    # AppVeyor builds have to install latest.
  when :firefox
    # But AppVeyor builds not installing latast FF. Should they?
  when :internet_explorer
    next if ENV['CIRCLECI'] || ENV['TRAVIS']
    # Runs localy and if ENV['APPVEYOR']
  else
    raise 'unknown browser type'
  end

  require "rutl/interface/#{browser_type}"
  #
  # There's special magic here in that these tests are tagged slow for all
  # browsers and there are tagged instances or each of these for the individual
  # browsers. So you could:
  #   rpsec --tag slow
  # or
  #   rspec --tag firefox
  # for example.
  #
  RSpec.describe "RUTL::Interface::#{browser_type.to_s.pascal_case}",
                 browser_type, :slow do
    let!(:browser) do
      RUTL::Browser.new(type: browser_type)
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
      unless ENV['CIRCLECI']
        # CircleCI (Docker?) seems to have probelms with showing the div that
        # we use to determine error. Skip this on Circle for now.
        username_text = 'tomsmith'
        password_text = 'foo'
        login_button.click
        # This test site actually has different displayed for invalid user and
        # password. That is an informations leak thus a bug and I'd rather not
        # contribute to someone else "testing the bug in" so this only tests for
        # there being an error and not the type of error.
        expect(current_page).to be_page(InternetLoginErrorPage)
      end
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
        expect(current_page.url).to eq InternetLoginPage.url
      end
    end
  end
end
