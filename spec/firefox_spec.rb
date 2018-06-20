require 'webdrivers' unless ENV['CIRCLECI']
require 'spec_helper'
require 'rutl/interface/firefox'

RSpec.describe RUTL::Interface::Firefox, :slow do
  let!(:browser) do
    RUTL::Browser.new(type: :firefox)
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
  end
end
