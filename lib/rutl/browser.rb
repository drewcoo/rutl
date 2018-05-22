require 'rutl/utilities'
require 'rutl/base_page'

#
# Currently called Browser, this top-level class controls a browser and
# a fake browser. It will soon call into apps, at which point I need to
# rethink this naming convention.
#
class Browser
  include Utilities

  def initialize(interface_type: :none, page_object_dir: 'spec/pages')
    @pages = load_pages(page_object_dir: page_object_dir)
    load_interface(type: interface_type)
  end

  def load_interface(type: :none)
    pages = @pages
    require "rutl/interface/#{type}_interface"
    klass = "#{type.to_s.capitalize}Interface"
    @interface = Object.const_get(klass).new(pages: pages)
    @interface.interface = @interface
  end

  # Ugly. Requires files for page objects. Returns array of class names to load.
  def require_pages(page_object_dir: 'spec/pages')
    names = []
    Dir["#{page_object_dir}/*"].each do |file|
      require "rutl/../../#{file}"
      File.open(file).each do |line|
        names << $1 if line =~ /class (.*) < BasePage/
      end
    end
    names
  end

  def load_pages(*)
    pages = []
    names = require_pages
    names.each do |klass|
      # Don't have @interface set yet.
      # That would have been the param to new, :interface.
      pages << Object.const_get(klass).new
    end
    pages
  end

  def method_missing(method, *args, &block)
    result = if args.empty?
               @interface.send(method)
             else
               @interface.send(method, *args, &block)
             end
    if result.class == Array && (result[0].class.ancestors.include?(BasePage) ||
                                 result[0].class == Exception)
      wait_for_transition(result)
    else
      result
    end
  end

  def respond_to_missing?(*args)
    @interface.respond_to?(*args)
  end
end
