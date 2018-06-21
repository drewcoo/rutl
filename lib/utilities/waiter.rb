#
# The waiter waits.
#
module Waiter
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
end
