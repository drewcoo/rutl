require 'rutl/application'
require 'rutl/version'
#
# TODO: Rename to something better. RubyUI2API? RAPID for Ruby API DSL?
# The idea is that this framework should be usable for web, phone, and even
# desktop UI testing, turning the UI into an API via its DSL.
#
module RUTL
  # maybe this doesn't exist so much anymore.
  # Should there be one flat directory? Nested dirs organized?
  # web pages aren't the same as app views (have urls)
  # or do I make them look the same?
  # Not have any methods for views that depend on url or have them explicitly
  # call out url and non-url versions.
  #
  # Should define RUTL::VIEWS directory for your code
  # or set ENV['RUTL_VIEWS']
  # or Application intialize will raise.
  # VIEWS = nil

  # HUNGARIAN automatically appends _<element_type> to all view elements.
  # So
  #   button :foo
  # is referred to later in code as
  #    foo_button
  # instead of just the flat name. So
  #   bar_link.click
  # instead of
  #   bar.click
  #
  # And I like it so it goes on by default.
  HUNGARIAN = true

  # If this RUTL::SCREENSHOT_DIR or ENV['SCREENSHOT_DIR']
  # or Application initialize is set, we take screenshots.
  # SCREENSHOTS = nil

  # This one is for diffing against.
  # RUTL::KNOWN_GOOD_SCREENSHOTS
  # REFERENCE_SCREENSHOTS = nil
end
