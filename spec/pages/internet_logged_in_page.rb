require 'rutl/page'

class InternetLoggedInPage < RUTL::Page
  @url = 'http://the-internet.herokuapp.com/secure'

  def layout
    button :logout,
           { css: 'i.icon-2x.icon-signout' },
           [InternetLoginPage]
    link :elemental_selenium,
         { css: '.large-4 > div:nth-child(2) > a:nth-child(1)' },
         ['elementalselenium.com']
    # Flash banner.
    # div#flash.flash.success shows some text on success
    # and otherwise not there
    #
    # This *might* be the X to close the banner.
    # body > div:nth-child(2) > a > img
  end
end
