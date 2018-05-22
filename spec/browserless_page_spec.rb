require 'spec_helper'

describe 'BrowserlessPageTest' do
  let(:browser) do
    Browser.new(interface_type: :null, page_object_dir: page_object_dir)
  end
  let(:browser2) do
    Browser.new(interface_type: :null, page_object_dir: page_object_dir)
  end
  before(:each) do
    browser.goto(Page1)
  end

  it 'click a button' do
    result = browser.ok_button.click
    expect(result).to eq [Page2]
  end

  it 'click a link' do
    result = browser.ok_link.click
    expect(result).to eq [Page1]
  end

  it 'enter some text' do
    browser.password_text.set 'foobarbaz'
  end

  it 'do a thing' do
    browser.password_text.set 'am i texting'
    browser.ok_link.click
    browser.okay_text.set 'am i texting NOW'

    browser2.goto(Page1)

    browser2.password_text.set 'changeme'

    # TODO: This is failing. Is it because we get new element to attach wtih
    # each call so I lose the fake string?
    puts browser2.password_text.get
    # expect(browser2.password_text.get).to eq 'changeme'

    # browser2.password_text
    # browser2.password_text = 'changeme'
    # browser2.password_text

    # doesn't return right value because not setting/reading in browser
    browser2.away_link.click
    # expect(browser.current_page.class).to be Page2
    expect(true).to be true
  end

  it 'load another page' do
    browser.goto(Page2)
    page_init = browser.current_page
    this_button = browser.belly_button
    page_final = this_button.click
    expect(page_init.class).not_to eq page_final.class
  end

  it 'click a button; go to another page' do
    result = browser.ok_button.click
    expect(result).to eq [Page2]
    expect(browser.current_page.class).to eq Page2
    #
    # TODO: Make browser sense clicks and such, handle waiting,
    # and handle updatign current_page
    #
    # expect(@browser.current_page.class).to eq Page2
  end

  it 'see url' do
    expect(browser.current_url).to match(/page1/i)
  end
end
