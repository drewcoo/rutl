#
# Extend string class to PascalCase* snake_cased_strings.
# Monkey patching that's only needed in this file so far.
# Move it to utilitiies? Other?
#
# * It's Pascal case, not camel case. It starts with a capital.
#
class String
  def pascal_case
    split('_').map(&:capitalize).join
  end
end
