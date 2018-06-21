#
# Extend string class to PascalCase* snake_cased_strings.
# Monkey patching that's only needed in this file so far.
# Move it to utilitiies? Other?
#
# * It's Pascal case, not camel case. It starts with a capital.
#
class String
  def pascal_case
    split('_').map(&:capitalize).join
  end
end

#
# A catch-all bag for stuff I don't have elsewhere yet.
#
module Utilities
  require 'timeout'

  POLL_SLEEP_TIME = 0.01
  DEFAULT_TIMEOUT = 5

  # The lambda passed to await should return false if thing not found
  # and something truthy if found
  def await(lamb, timeout = DEFAULT_TIMEOUT, poll_sleep_time = POLL_SLEEP_TIME)
    Timeout.timeout(timeout) do
      loop do
        result = lamb.call
        return result if result
        # rubocop:disable Style/SleepCop
        sleep poll_sleep_time
        # rubocop:enable Style/SleepCop
      end
    end
  end

  def class_info(object)
    result = "CLASS: #{object.class}"
    result += "\nmethods: #{(object.methods - Class.methods).sort}\n"
    result
  end

  # Just call "caller" with no args for stack trace.
  def location
    caller(1..1).first
  end

  def page?(checkme)
    checkme.ancestors.include?(RUTL::Page)
  rescue NoMethodError
    # This isn't a even a class. It's no page!
    false
  end
end
