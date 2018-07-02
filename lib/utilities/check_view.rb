#
# #view? is used in interface/base.rb and in rspec/rutl_matchers.rb
# so the method lives over in this lonely place.
#
module CheckView
  def view?(checkme)
    checkme.ancestors.include?(RUTL::View)
  rescue NoMethodError
    false
  end
  alias page? view?
end
