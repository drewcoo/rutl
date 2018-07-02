require 'rutl/view'

class View2 < RUTL::View
  @url = 'http://somesite.org/bar.html'

  def layout
    button :belly, { css: 'where' }, [View1]
    button :ok, { css: 'some_css' }, [View1]
  end
end
