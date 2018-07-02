require 'rutl/view'

class View1 < RUTL::View
  @url = 'http://somesite.html/foo.html'

  def layout
    button :ok, { css: 'some_css' }, [View2]
    link :ok, { css: 'some css to link' }, [View1]
    text :password, { css: 'some/other/css' }
    text :okay, { css: 'ORLY' }
    link :away, { css: 'go/away/now/link' }, [View2]
  end
end
