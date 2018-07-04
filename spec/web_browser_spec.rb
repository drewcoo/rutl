require 'spec_helper'
require 'utilities/string'
require 'webdrivers' unless ENV['CIRCLECI']

%i[chrome firefox internet_explorer].freeze.each do |browser_type|
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
    let(:app) do
      browser = RUTL::Application.new(family: :browser, type: browser_type,
                                      views: 'spec/views/web')
      browser.goto(InternetLoginView)
      browser
    end

    after do
      app.quit if defined?(app) && !app.nil?
    end

    context 'with text field' do
      it 'read/write' do
        username = 'foo'
        username_text.set username
        expect(username_text).to eq username
      end

      it 'clear' do
        username = 'foo'
        username_text.set username
        username_text.clear
        expect(username_text).to eq ''
      end
    end

    context 'with password field' do
      it 'read' do
        username = 'foo'
        username_text.set username
        expect(username_text).to eq username
      end
    end

    it 'fails bad login' do
      unless ENV['CIRCLECI'] || ENV['TRAVIS']
        # CircleCI (Docker?) seems to have probelms with showing the div that
        # we use to determine error. Skip this on Circle for now.
        #
        # Looks like Travis does now, too. New version of something?
        #
        # This works locally and on Appveyor. Unlike Circle and Travis they're
        # Windows.
        #
        username_text.set 'tomsmith'
        password_text.set 'foo'
        login_button.click
        # This test site actually has different displayed for invalid user and
        # password. That is an informations leak thus a bug and I'd rather not
        # contribute to someone else "testing the bug in" so this only tests for
        # there being an error and not the type of error.
        expect(current_view).to be_view(InternetLoginErrorView)
      end
    end

    context 'when log in' do
      before do
        app.username_text.set 'tomsmith'
        app.password_text.set 'SuperSecretPassword!'
        login_button.click
      end

      it 'lands on logged in view' do
        expect(current_view).to be_view(InternetLoggedInView)
      end

      it 'can log back out' do
        logout_button.click
        expect(current_view.url).to eq InternetLoginView.url
      end
    end
  end
end
