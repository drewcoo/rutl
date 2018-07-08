require 'selenium-webdriver'
require 'rutl/interface/base'

module RUTL
  module Interface
    #
    # Small interface for Chrome browser.
    #
    class Browser < Base
      def initialize
        super
      end

      def current_view
        url = @driver.current_url
        view = find_view(url)
        raise "NOT FOUND: #{url}, VIEWS: #{@views}" unless view
        view
      end
    end
  end
end
