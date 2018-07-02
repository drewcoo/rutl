require 'coveralls'
Coveralls.wear!

require 'fileutils'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rspec/default_rspec_to_application'
require 'rspec/rutl_matchers'

RUTL::SCREENSHOTS = 'tmp/screenshots'.freeze
# The framework should do this.
FileUtils.rm_rf(RUTL::SCREENSHOTS)

RSpec.configure do |config|
  config.after do
    application.quit if defined?(application) && !application.nil?
  end
  config.color = true
  # I was having trouble seeing the red. Time for a checkup?
  config.failure_color = :cyan
  config.disable_monkey_patching!
  config.fail_fast = 0
  config.filter_run focus: true
  config.include DefaultRspecToApplication
  config.order = :random
  config.run_all_when_everything_filtered = true
end
