#
# A catch-all bag for stuff I don't have elsewhere yet.
#
module Utilities
  require 'timeout'

  POLL_SLEEP_TIME = 0.1
  DEFAULT_TIMEOUT = 5

  # The lambda passed to await should return false if thing not found
  # and something truthy if found
  def await(lamb, timeout = DEFAULT_TIMEOUT, poll_sleep_time = POLL_SLEEP_TIME)
    Timeout.timeout(timeout) do
      loop do
        result = lamb.call
        return result if result
        sleep poll_sleep_time
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
    checkme.ancestors.include?(BasePage)
  rescue # BUGBUG: Didn't have time to find all the things to rescue yet.
    false
  end

  def raise_if_not_page(page)
    raise "NOT A PAGE: #{page}. Ancestors: #{page.ancestors}" unless page?(page)
  end
end
