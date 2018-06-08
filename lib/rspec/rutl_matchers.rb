require 'utilities'
#
# Additional RSpec matchers specific to this framework go here.
#

# Is it the expected page?
RSpec::Matchers.define :be_page do |expected|
  match do |actual|
    actual.is_a?(expected) && page?(expected)
  end
end
