#
# Currently not in use.
# Should go in its own file, too.
#
module DefaultRspecToBrowser
  # rubocop:disable Style/MethodMissingSuper
  def method_missing(method, *args, &block)
    if args.empty?
      browser.send(method)
    else
      browser.send(method, *args, &block)
    end
  rescue ArgumentError
    browser.send(method)
  end
  # rubocop:enable Style/MethodMissingSuper

  def respond_to_missing?(method, _include_private = false)
    return false if method =~ /browser/
    browser.respond_to?(method)
  end
end
