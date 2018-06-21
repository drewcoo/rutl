#
# Helper method without a home.
# Page.page?(foo) didn't feel right.
# And though it's mostly in interface/base it's also used in the
# RSpec matcher and it doesn't make sense to pull interface/base into that.
#
module CheckPage
  def page?(checkme)
    checkme.ancestors.include?(RUTL::Page)
  rescue NoMethodError
    # This isn't a even a class. It's no page!
    false
  end
end
