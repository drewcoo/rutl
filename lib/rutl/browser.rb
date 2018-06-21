require 'rutl/page'
require 'utilities/string'

module RUTL
  #
  # Currently called Browser, this top-level class controls a browser and
  # a fake browser. It will soon call into apps, at which point I need to
  # rethink this naming convention.
  #
  class Browser
    attr_reader :interface

    def initialize(type:, rutl_pages: RUTL::PAGES || ENV['RUTL_PAGES'])
      if rutl_pages.nil? || rutl_pages.empty?
        raise "Set RUTL::PAGES or ENV['RUTL_PAGES'] or pass dir as rutl_pages:"
      end
      # This is kind of evil. Figure out how to ditch the $ variable.
      $browser = self
      @interface = nil # TODO: Why this line? Do I need to do this?
      @interface = load_interface(type)
      @interface.pages = load_pages(dir: rutl_pages)
    end

    def method_missing(method, *args, &block)
      if args.empty?
        @interface.send(method)
      else
        @interface.send(method, *args, &block)
      end
    end

    def respond_to_missing?(*args)
      @interface.respond_to?(*args)
    end

    private

    def load_interface(type)
      require "rutl/interface/#{type}"
      klass = "RUTL::Interface::#{type.to_s.pascal_case}"
      Object.const_get(klass).new
    end

    def load_pages(*)
      pages = []
      require_pages.each do |klass|
        # Don't have @interface set yet.
        # That would have been the param to new, :interface.
        pages << Object.const_get(klass).new(@interface)
      end
      pages
    end

    # Ugly. Requires files for page objects.
    # Returns array of class names to load.
    def require_pages(dir: 'spec/pages')
      names = []
      Dir["#{dir}/*"].each do |file|
        require "rutl/../../#{file}"
        File.open(file).each do |line|
          bingo = line.match(/class (.*) < RUTL::Page/)
          names << bingo[1] if bingo && bingo[1]
        end
      end
      names
    end
  end
end
