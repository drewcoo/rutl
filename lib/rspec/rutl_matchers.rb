require 'utilities/check_page'
#
# Additional RSpec matchers specific to this framework go here.
#
module RSpec
  include CheckPage

  Matchers.define :be_page do |expected|
    match do |actual|
      actual.is_a?(expected) && page?(expected)
    end
  end
end
