require 'spec_helper'
require 'rutl/interface/null_interface'

RSpec.describe NullInterface, :fast do
  let!(:browser) do
    Browser.new(type: :null)
  end

  let(:browser2) do
    Browser.new(type: :null)
  end

  before do
    goto(Page1)
  end

  it 'click a button and check the return' do
    result = ok_button.click
    expect(result).to be_page(Page2)
  end

  it 'click a link and check the return' do
    result = ok_link.click
    expect(result).to be_page(Page1)
  end

  it 'click a button and check the page' do
    ok_button.click
    expect(current_page).to be_page(Page2)
  end

  it 'click a link and check the page' do
    ok_link.click
    expect(current_page).to be_page(Page1)
  end

  it 'enter some text' do
    password_text = 'foobarbaz'
    expect(password_text).to eq 'foobarbaz'
  end

  it 'do a thing' do
    password_text = 'am i texting'
    ok_link.click
    expect(okay_text.to_s).to eq ''
  end

  it 'load another page' do
    goto(Page2)
    page_init = current_page
    page_final = belly_button.click
    expect(page_init).not_to be_instance_of(page_final.class)
  end

  context 'when click a button' do
    it 'goes to another page' do
      ok_button.click
      expect(current_page).to be_page(Page2)
    end
  end

  it 'see url' do
    expect(current_page.url).to match(/page1/i)
  end

  context 'with another browser intance' do
    before do
      # We have to call this browser by name.
      # The shortcut assumes we're going to "browser."
      browser2.goto(Page1)
    end

    it 'reads and write text' do
      browser2.goto(Page1)
      browser2.password_text = 'changeme'
      expect(browser2.password_text).to eq 'changeme'
    end

    it 'changes text' do
      browser2.goto(Page1)
      browser2.password_text = 'changeme'
      browser2.password_text = 'changed'
      expect(browser2.password_text).to eq 'changed'
    end

    it 'changes multiple fake text fields' do
      browser2.goto(Page1)
      browser2.password_text = 'foo'
      browser2.okay_text = 'bar'
      expect(browser2.password_text).to eq 'foo'
    end
  end
end
