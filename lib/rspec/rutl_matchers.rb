require 'utilities/check_view'
#
# Additional RSpec matchers specific to this framework go here.
#
module RSpec
  include CheckView

  Matchers.define :be_view do |expected|
    match do |actual|
      actual.is_a?(expected) && view?(expected)
    end
  end
end
