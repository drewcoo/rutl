lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rutl'

Gem::Specification.new do |spec|
  spec.name          = 'rutl'
  spec.version       = RUTL::VERSION
  spec.authors       = ['Drew Cooper']
  spec.email         = ['drewcoo@gmail.com']

  spec.summary       = 'Ruby Ui Test Library'
  spec.description   = 'One gem to test them all and in the darkness bug them.'
  spec.homepage      = 'https://github.com/drewcoo/rutl'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  if ENV['CIRCLECI'].nil?
    spec.add_development_dependency 'chromedriver-helper', '~> 1.2'
  end
  # spec.add_development_dependency 'geckodriver-helper', '~>  0.20'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'rubocop', '~> 0.55'
  spec.add_development_dependency 'selenium-webdriver', '~> 3.12'
end
