#
# Tries to send any method to application.method instead.
#
# Sadly, Ruby doesn't allow this to work work with naked assignments. So
#   foo_button.click # turns into application.foo_button.click
#   bar_text == 'baz' # turns into application.bar_text == 'baz'
# but
#   quux = 'quuux' # just stays quux = 'quuux'
#
module DefaultMethodObjectToApp
  # rubocop:disable Style/MethodMissingSuper
  def method_missing(method, *args, &block)
    super unless respond_to_missing? method
    if args.empty?
      app.send(method)
    else
      app.send(method, *args, &block)
    end
  rescue ArgumentError
    app.send(method)
  end
  # rubocop:enable Style/MethodMissingSuper

  def respond_to_missing?(method, _include_private = false)
    return false if method =~ /^app$/
    app.respond_to?(method)
  end
end
