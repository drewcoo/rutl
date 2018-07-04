require 'coveralls'
Coveralls.wear!

require 'fileutils'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
#
# Consider removing default_method_object_to_app.rb and any reference to
# DefaultMethodObjectToApp given that it won't work with the way I assign
# text fields with the equal sign.
#   foo_text = 'imastring!'
# The above always reults in a setting a local varaible and does not set
# app.foo_text.
#
require 'rspec/default_method_object_to_app'
require 'rspec/rutl_matchers'

RUTL::SCREENSHOTS = File.expand_path('../tmp/screenshots', __dir__)

# RUTL should really handle this itself instead of spec_helper
FileUtils.rm_rf(RUTL::SCREENSHOTS)

RSpec.configure do |config|
  config.color = true
  # I was having trouble seeing the red. Time for a checkup?
  config.failure_color = :cyan
  config.disable_monkey_patching!
  config.fail_fast = 0
  config.filter_run focus: true
  config.include DefaultMethodObjectToApp
  config.order = :random
  config.run_all_when_everything_filtered = true
end
