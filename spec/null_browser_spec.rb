require 'spec_helper'

RSpec.describe 'RUTL::Interface::Null', :fast do
  let!(:application) do
    RUTL::Application.new(family: :browser, type: :null,
                          views: 'spec/views/web')
  end

  let(:browser2) do
    RUTL::Application.new(family: :browser, type: :null,
                          views: 'spec/views/web')
  end

  before do
    goto(View1)
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
    password_text = 'foobarbaz'
    expect(password_text).to eq 'foobarbaz'
  end

  it 'do a thing' do
    password_text = 'am i texting'
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
    before do
      # We have to call this browser by name.
      # The shortcut assumes we're going to "browser."
      browser2.goto(View1)
    end

    it 'reads and write text' do
      browser2.goto(View1)
      browser2.password_text = 'changeme'
      expect(browser2.password_text).to eq 'changeme'
    end

    it 'changes text' do
      browser2.goto(View1)
      browser2.password_text = 'changeme'
      browser2.password_text = 'changed'
      expect(browser2.password_text).to eq 'changed'
    end

    it 'changes multiple fake text fields' do
      browser2.goto(View1)
      browser2.password_text = 'foo'
      browser2.okay_text = 'bar'
      expect(browser2.password_text).to eq 'foo'
    end
  end
end
