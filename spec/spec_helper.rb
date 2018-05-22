$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rutl'

module DefaultRspecToBrowser
  def method_missing(method, *args, &block)
    browser.send(method, args, block)
  rescue ArgumentError
    browser.send(method)
  end

  def respond_to_missing?(method)
    browser.respond_to?(method)
  end
end

RSpec.shared_context 'globals' do
  let(:page_object_dir) { 'spec/pages' }
end

RSpec.configure do |config|
  # config.include DefaultRspecToBrowser
  config.order = :random
  config.fail_fast = 0
  config.include_context 'globals'
  config.after do
    browser.quit if defined?(browser) && !browser.nil?
  end
end
