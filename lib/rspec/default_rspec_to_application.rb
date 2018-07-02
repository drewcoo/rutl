#
# Currently not in use.
# Should go in its own file, too.
#
module DefaultRspecToApplication
  # rubocop:disable Style/MethodMissingSuper
  def method_missing(method, *args, &block)
    if args.empty?
      application.send(method)
    else
      application.send(method, *args, &block)
    end
  rescue ArgumentError
    application.send(method)
  end
  # rubocop:enable Style/MethodMissingSuper

  def respond_to_missing?(method, _include_private = false)
    return false if method =~ /application/
    application.respond_to?(method)
  end
end
