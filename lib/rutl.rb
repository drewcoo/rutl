require 'rutl/browser'
require 'rutl/version'
#
# TODO: Rename to something better. RubyUI2API? RAPID for Ruby API DSL?
# The idea is that this framework should be usable for web, phone, and even
# desktop UI testing, turning the UI into an API via its DSL.
#
module RUTL
  # Should define RUTL::PAGES directory for your code
  # or set ENV['RUTL_PAGES']
  # or Browser intialize will raise.
  PAGES = nil

  # If this RUTL::SCREENSHOT_DIR or ENV['SCREENSHOT_DIR']
  # or Browser initialize is set, we take screenshots.
  SCREENSHOTS = nil

  # This one is for diffing against.
  # RUTL::KNOWN_GOOD_SCREENSHOTS
  REFERENCE_SCREENSHOTS = nil
end
