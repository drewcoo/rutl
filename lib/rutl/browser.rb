require 'rutl/utilities'
require 'rutl/base_page'

#
# Currently called Browser, this top-level class controls a browser and
# a fake browser. It will soon call into apps, at which point I need to
# rethink this naming convention.
#
class Browser
  include Utilities

  attr_reader :interface

  def initialize(interface_type:, page_object_dir: 'spec/pages')
    # This is kind of evil. Figure out how to ditch the $ variable.
    $browser = self
    @interface = nil
    @interface = load_interface(interface_type)
    @interface.pages = load_pages(dir: page_object_dir)
  end

  def load_interface(type)
    require "rutl/interface/#{type}_interface"
    klass = "#{type.to_s.capitalize}Interface"
    Object.const_get(klass).new
  end

  # Ugly. Requires files for page objects. Returns array of class names to load.
  def require_pages(dir: 'spec/pages')
    names = []
    Dir["#{dir}/*"].each do |file|
      require "rutl/../../#{file}"
      File.open(file).each do |line|
        bingo = line.match(/class (.*) < BasePage/)
        names << bingo[1] if bingo && bingo[1]
      end
    end
    names
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
end
