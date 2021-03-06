require 'spec_helper'

RSpec.describe 'RUTL::Interface::Null', :fast do
  let(:app) do
    browser = RUTL::Application.new(family: :browser, type: :null,
                                    views: 'spec/views/web')
    browser.goto(View1)
    browser
  end

  let(:browser2) do
    browser = RUTL::Application.new(family: :browser, type: :null,
                                    views: 'spec/views/web')
    browser.goto(View1)
    browser
  end

  it 'click a button and check the return' do
    result = ok_button.click
    expect(result).to be_view(View2)
  end

  it 'click a link and check the return' do
    result = ok_link.click
    expect(result).to be_view(View1)
  end

  it 'click a button and check the view' do
    ok_button.click
    expect(current_view).to be_view(View2)
  end

  it 'click a link and check the view' do
    ok_link.click
    expect(current_view).to be_view(View1)
  end

  it 'enter some text' do
    password_text.set 'foobarbaz'
    expect(password_text).to eq 'foobarbaz'
  end

  it 'do a thing' do
    password_text.set 'am i texting'
    ok_link.click
    expect(okay_text.to_s).to eq ''
  end

  it 'load another view' do
    goto(View2)
    view_init = current_view
    view_final = belly_button.click
    expect(view_init).not_to be_instance_of(view_final.class)
  end

  context 'when click a button' do
    it 'goes to another view' do
      ok_button.click
      expect(current_view).to be_view(View2)
    end
  end

  it 'see url' do
    expect(current_view.url).to match(/foo\.html/i)
  end

  context 'with another browser instance' do
    it 'reads and write text' do
      browser2.password_text.set 'changeme'
      expect(browser2.password_text).to eq 'changeme'
    end

    it 'changes text' do
      browser2.password_text.set 'changeme'
      browser2.password_text.set 'changed'
      expect(browser2.password_text).to eq 'changed'
    end

    it 'changes multiple fake text fields' do
      browser2.password_text.set 'foo'
      browser2.okay_text.set 'bar'
      expect(browser2.password_text).to eq 'foo'
    end
  end
end
