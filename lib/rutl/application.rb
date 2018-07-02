require 'rutl/view'
require 'utilities/string'

module RUTL
  #
  # Application, this top-level class, controls a browser and
  # a fake browser. It will soon call into apps, at which point I need to
  # rethink this naming convention.
  #
  class Application
    attr_reader :interface

    def initialize(type:, rutl_views: RUTL::VIEWS || ENV['RUTL_VIEWS'])
      if rutl_views.nil? || rutl_views.empty?
        raise "Set RUTL::VIEWS or ENV['RUTL_VIEWS'] or pass dir as rutl_views:"
      end
      # This is kind of evil. Figure out how to ditch the $ variable.
      $application = self
      @interface = nil # TODO: Why this line? Do I need to do this?
      @interface = load_interface(type)
      @interface.views = load_views(directory: rutl_views)
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

    def load_views(directory:)
      require_views(directory: directory).map do |klass|
        Object.const_get(klass).new(@interface)
      end
    end

    # Ugly. Requires files for view objects.
    # Returns array of class names to load.
    def require_views(directory:)
      Dir["#{directory}/*"].map do |file|
        result = find_class_name(file)
        result if result
      end
    end

    def find_class_name(file)
      require "rutl/../../#{file}"
      File.open(file).each do |line|
        bingo = line.match(/class (.*) < RUTL::View/)
        # One class per file.
        return bingo[1] if bingo && bingo[1]
      end
      false
    end
  end
end
