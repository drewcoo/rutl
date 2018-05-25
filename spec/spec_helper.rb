require 'coveralls'
Coveralls.wear!

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

RSpec.shared_context 'with globals' do
  let(:page_object_dir) { 'spec/pages' }
end

RSpec.configure do |config|
  config.after do
    browser.quit if defined?(browser) && !browser.nil?
  end
  config.disable_monkey_patching!
  config.fail_fast = 0
  config.filter_run focus: true
  # config.include DefaultRspecToBrowser
  config.include_context 'with globals'
  config.order = :random
  config.run_all_when_everything_filtered = true
end
