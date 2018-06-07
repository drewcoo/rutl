require 'rutl/page'

class Page1 < RUTL::Page
  @url = 'http://somesite.html/page1.html'

  def layout
    button :ok, { css: 'some_css' }, [Page2]
    link :ok, { css: 'some css to link' }, [Page1]
    text :password, { css: 'some/other/css' }
    text :okay, { css: 'ORLY' }
    link :away, { css: 'go/away/now/link' }, [Page2]
  end
end
