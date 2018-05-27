lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rutl'

Gem::Specification.new do |spec|
  spec.name          = 'rutl'
  spec.version       = RUTL::VERSION
  spec.authors       = ['Drew Cooper']
  spec.email         = ['drewcoo@gmail.com']

  spec.summary       = 'Ruby Ui Test Library'
  spec.description   = 'DANGER!!! DO NOT USE YET!!! This is a UI library ' \
                       'under construction and only name-squatting for the ' \
                       'moment.'
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

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'drewcoo-cops', '~> 0.1'
  spec.add_development_dependency 'gem-release', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'rubocop', '~> 0.55'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.25'
  spec.add_development_dependency 'selenium-webdriver', '~> 3.12'
  spec.add_development_dependency 'webdrivers', '~> 3.0'
end
