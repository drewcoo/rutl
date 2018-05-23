# RUTL

[![TravisCI](https://api.travis-ci.org/drewcoo/rutl.svg)](https://travis-ci.org/drewcoo/rutl)
[![CircleCI](https://circleci.com/gh/drewcoo/rutl.svg?style=shield)](https://circleci.com/gh/drewcoo/rutl)
[![Coverage Status](https://coveralls.io/repos/github/drewcoo/rutl/badge.svg?branch=master)](https://coveralls.io/github/drewcoo/rutl?branch=master)

This is the Ruby Ui Test Library, or RUTL. Not to be confused with the Rutles.
https://www.rutles.org/

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

    ```ruby
    gem 'rutl'
    ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rutl

## Usage

TODO: Write usage instructions here

## Roadmap
Coming up soon in almost no order:
* Make browser tests work on TravisCI.
* A test framework should have better tests. Goes with next bullet.
* Flesh out null interface/driver. Make them do what a real browser does.
* Make geckodriver work. Geckodriver-helper is failing me.
* Restructure tests to handle fake browsers and real browsers. Same structure?
* Make this work with pages in some other location so we can use it as a gem.
* Make work with TravisCI.
* Put more info in this readme.
* Take screenshots.
* Diff screenshots. Make this smart so we don't have to be experts.
* InternetExplorerDriver
* Other browser drivers? Look at https://github.com/fnando/browser
* Get this working with Appium:
  * Make TK app to test on desktops and test it.
  * Make Android example app and get this to work.
  * Same with iPhone.
* Others?
* Spidering page object maker.
* Possibly pair the null browser with auto-generated pages for ______?
* Call rutl.rb properly.
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
    `bundle exec rubocop`

### delete?
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drewcoo/rutl.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
