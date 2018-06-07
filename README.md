# RUTL

[![TravisCI](https://api.travis-ci.org/drewcoo/rutl.svg)](https://travis-ci.org/drewcoo/rutl)
[![CircleCI](https://circleci.com/gh/drewcoo/rutl.svg?style=shield)](https://circleci.com/gh/drewcoo/rutl)
[![Coverage Status](https://coveralls.io/repos/github/drewcoo/rutl/badge.svg?branch=master)](https://coveralls.io/github/drewcoo/rutl?branch=master)
[![Gem Version](https://badge.fury.io/rb/rutl.svg)](https://badge.fury.io/rb/rutl)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/f95d69f6bdd149e697cf63e842f71600)](https://www.codacy.com/app/drewcoo/rutl?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=drewcoo/rutl&amp;utm_campaign=Badge_Grade)

This is the Ruby Ui Test Library, or RUTL. Not to be confused with [The Rutles](https://www.rutles.org/).

Framework goals:
* Define what's on a page in an easy, flexible way. Easy page objects!
* Abstract away things that make tests buggy and painful to maintain.
* Write test cases for native apps, the web, and desktop apps the same way.
* Make screenshotting and diffing screenshots sane and easy.
* TODO: I'm sure I'm missing some at the moment.
* Secondary-ish goal: Make fake browser to test the framework faster.
* Tertiary-ish: Stop calling browser "fake" because I'm sick of that word. Null!


## Installation

Add this line to your application's Gemfile:

    $ gem 'rutl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rutl


## Usage

### Page Objects
Page objects are a common paradigm in browser testing. This framework uses the
following convention for page classes:
* must inherit from Rutl::BasePage (require rutl/base_page)
* by default, the class should follow the naming convention ending with "Page" (optional?)
* must have @url defined per page
* must have a layout method such that
 * field types are defined by methods button, checkbox, link, and text (more tbd?)
 * field type is followed by name as a symbol (add support for string? tbd)
 * then a comma
 * hash of selectors
   * key is selector type as symbol (currently only :css)
   * value is string path
 * optional comma if there are destinations or error conditions
 * optional array of destination page or error condition classes if clicking the element causes transition
* loaded? method returning boolean to determine when page is loaded
  * defaults to just checking url; overide as needed
* go_to_here (better name?) method to navigate to the page if we can't just go to the url
* your own methods because it's a plain ol' Ruby class


 Example:

```ruby
    require 'rutl/base_page'

    class MyPage < BasePage
      @url = 'https://url.string.com/page.html'

      def layout
        text :username, { css: 'some_css_input#username' }
        text :password, { css: 'css#to_password_field' }
        button :log_me_in, { css: 'button#login' }, [SomeOtherPage, LoginFailurePage]
        link :refresh, { css: 'link_css_to_refresh_page' }, [MyPage]
      end
    end
```

And here's some example RSpec:

```ruby
    require 'spec_helper'

    RSpec.describe MyTest do
      let!(:browser) do
        Browser.new(type: :firefox)
      end

      it 'logs in' do
        goto(MyPage)
        username_text = 'drew'
        password_text = 's3cr3T!'
        log_me_in_button.click
        expect(current_page).to be_page(SomeOtherPage)
      end
    end
```

The framework loads and manages all the pages. You just have to interact with
what you can see on whatever page you're on. Let's walk through this.
* TBD: Does RUTL come with browser drivers? Browsers? What needs to be added?
* We're using let! because:
  * it forces instantiation of "browser" every time
  * we include DefaultRspecToBrowser, defaulting missing methods to "browser"
  * thus the terse lines that follow
* We didn't pass named param rutl_pages: to Browser so we must have done one of:
  * setting environment variable RUTL_PAGES
  * setting RUTL::PAGES
* Browser's type: parameter currently supports :chrome, :firefox, and :null.
* The first call to the browser is goto because it wasn't on a page.
* Auto-created fields are named "#{friendly_name}_#{field_type}".
* Getting and setting text fields is as easy as calling a String.
* When we call click, the framework polls for a next state.
* We verify that the current page is an instance of the intended page.
  * Also note here that we have a matcher be_page which matches a page class.

### RSpec Goodies

The tests here are in RSpec and use some conventions that may be common if your tests are also RSpec.

#### DefaultRspecToBrowser
This is a module that allows us to skip writing `browser.` in front of everything.
1. We assume that `browser` is defined.
2. On method_missing, we try to send the method to `browser`.

It lets us turn this:
```
    browser.field1_text = 'foo'
    browser.ok_button.click
    expect(browser.current_page).to eq(NextPage)
```
into this:
```
    field1_text = 'foo'
    ok_button.click
    expect(current_page).to eq(NextPage)
```
which means less boilerplate and it's easier to follow.

To use it:
```
    require 'rutl/rspec/default_rspec_to_browser'
```

#### RSpec Matcher

Currently the only has the `be_page` matcher.

It lets us turn this:
```
    expect(browser.current_page).to be_instance_of(MyPage)
```
into this:
```
    expect(browser.current_page).to be_page(MyPage)
```
Both are acceptable but the second is more readable.

To use it:
```
    require 'rutl/rspec/rutl_matchers'
```

### Auto-screenshotting

If you have RUTL::SCREENSHOTS or ENV['SCREENSHOTS'] set to a directory, RUTL
will automatically take screenshots on page transitions.
If you're using RSpec, they'll be automatically named something based on the
RSpec description with an auto-incrementing number.
If you're not using RSpec, that's not terribly useful but you can always have
your tests screenshot anyway, just less magic.

## Roadmap
Coming up soon in almost no order:
* Handle error pages/partials.
* Auto-screenshot on errors. Error destinations. Navigation errors. Unexpected exceptions?
* A test framework should have better tests.
* Diff screenshots. Make this smart so we don't have to be experts.
* Put more info in this readme.
* Move bugs and would-be features to Github Issues instead of this readme and scattered through the code.
* Make the framework make it easier to spot bugs in pages. Focus on exception-handling?
* The webdriver gem should already include InternetExplorerDriver. Maybe run tests on AppVeyor.
* Other browser drivers? Look at https://github.com/fnando/browser
* Get this working with Appium:
  * Make TK app to test on desktops and test it.
    * Can Ruby TK create accesible apps? Not in the simple demos.
  * Make Android example app and get this to work.
    * Corboba?
  * Same with iPhone.
    * Same Cordoba test app?
* Documentation. RDoc?
* Auto-screenshot support frameworks other than RSpec.
* Others?
* Spidering page object maker. Or selector checker/fixer?
* Possibly pair the null browser with auto-generated pages for ______?
* Optional install of test resources based on machine type.
* Instructions about machine installs to help people using gem.
* Pair with some kind of VM, Docker container, AMI, or something.


## Development

Set everything up:

    1. Check out the repo.
    2. `cd` to the repo.
    3. `bundle install`
    4. `bundle exec rake`

Great! You've checked out the code, installed everything and run the tests.

Rubocop. I still have to tweak what I want it to complain about.
```ruby
    bundle exec rubocop
```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drewcoo/rutl.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
