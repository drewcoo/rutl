#
# Additional RSpec matchers specific to this framework go here.
#
RSpec::Matchers.define :be_page do |expected|
  match do |actual|
    actual.is_a?(expected) && expected.ancestors.include?(BasePage)
  end
end
