lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rutl'

Gem::Specification.new do |spec|
  spec.name          = 'rutl'
  spec.version       = RUTL::VERSION
  spec.authors       = ['Drew Cooper']
  spec.email         = ['drewcoo@gmail.com']

  spec.summary       = 'Ruby Ui Test Library'
  spec.description   = 'This is a UI library under construction at the moment.'
  spec.homepage      = 'https://github.com/drewcoo/rutl'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/gems/rutl'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # These are *some* webdriver-related dependencies. They don't include
  # brwosers. Or anything for non-browssr testing. Or image diffing code.
  # Maybe all browser stuff should be its own sub-gem.
  spec.add_dependency 'selenium-webdriver', '~> 3.12'
  # webdrivers gem can pull down these webdrivers: chromedriver, geckodriver,
  # IEDriverServer and MicrosoftWebDriver. It does not install the browser.
  #
  # CitcleCI can't use this to install webdrivers.
  # Works locally and with Travis.
  spec.add_dependency 'webdrivers', '~> 3.0'

  # everything but browsers
  spec.add_dependency 'appium_lib', '~> 9.14'
  # need eventmachine for Appium
  spec.add_dependency 'eventmachine', '~> 1.2'
  # using this to talk HTTP to the Appium server
  spec.add_dependency 'faraday', '~> 0.15'
  if ENV['OS'] == 'Windows_NT'
    # to get native window handles on Windows
    spec.add_dependency 'win32-window', '~> 0.2.0.pre'
    # my test app uses this
    spec.add_dependency 'tk', '~> 0.2'
  end

  # Dependencies for development only.
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'gem-release', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 12.3'

  # Code coverage service.
  spec.add_development_dependency 'coveralls', '~> 0.8'

  # RSpec is used to test the RUTL. It might not be the test engine chosen
  # by the person using RUTL.
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'

  # Linting with RuboCop
  spec.add_development_dependency 'drewcoo-cops', '~> 0.1'
  spec.add_development_dependency 'rubocop', '~> 0.55'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.25'
end
