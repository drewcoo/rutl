require 'rutl/page'

class InternetLoginPage < RUTL::Page
  @url = 'http://the-internet.herokuapp.com/login'

  def layout
    text :username, { css: 'input#username' } # tomsmith
    text :password, { css: 'input#password' } # SuperSecretPassword
    button :login,
           { css: 'i.fa.fa-2x.fa-sign-in' },
           [InternetLoggedInPage, InternetLoginErrorPage]
    link :elemental_selenium,
         { css: '.large-4 > div:nth-child(2) > a:nth-child(1)' },
         ['elementalselenium.com']
    element :error_banner, { css: 'div#flash.flash.error' }
    # div#flash.flash.success shows some text on success
    # AND same on logged in page
    # div#flash.flash.error on error
    # and otherwise not there
  end

  def loaded?
    !error_banner_element.exists? && super
  end
end
