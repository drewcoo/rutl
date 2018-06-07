require 'rutl/base_page'

class Page2 < BasePage
  @url = 'http://somesite.org/page2.html'

  def layout
    button :belly, { css: 'where' }, [Page1]
    button :ok, { css: 'some_css' }, [Page1]
  end
end
