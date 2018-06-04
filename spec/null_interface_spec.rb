require 'spec_helper'
require 'rutl/interface/null_interface'

RSpec.describe NullInterface, :fast do
  let(:browser) do
    Browser.new(interface_type: :null, page_object_dir: page_object_dir)
  end

  let(:browser2) do
    Browser.new(interface_type: :null, page_object_dir: page_object_dir)
  end

  before do
    browser.goto(Page1)
  end

  it 'click a button and check the return' do
    result = browser.ok_button.click
    expect(result).to be_instance_of(Page2)
  end

  it 'click a link and check the return' do
    result = browser.ok_link.click
    expect(result).to be_instance_of(Page1)
  end

  it 'click a button and check the page' do
    browser.ok_button.click
    expect(browser.current_page).to be_instance_of(Page2)
  end

  it 'click a link and check the page' do
    browser.ok_link.click
    expect(browser.current_page).to be_instance_of(Page1)
  end

  it 'enter some text' do
    browser.password_text = 'foobarbaz'
    expect(browser.password_text).to eq 'foobarbaz'
  end

  it 'do a thing' do
    browser.password_text = 'am i texting'
    browser.ok_link.click
    browser.okay_text = 'am i texting NOW'
  end

  it 'load another page' do
    browser.goto(Page2)
    page_init = browser.current_page
    page_final = browser.belly_button.click
    expect(page_init).not_to be_instance_of(page_final.class)
  end

  context 'when click a button' do
    it 'goes to another page' do
      browser.ok_button.click
      expect(browser.current_page).to be_instance_of(Page2)
    end
  end

  it 'see url' do
    expect(browser.current_page.url).to match(/page1/i)
  end

  context 'with another browser intance' do
    before do
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
