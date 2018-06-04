require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

task :fast_first do
  Rake::Task['spec'].invoke('fast')
  Rake::Task['spec'].reenable
  Rake::Task['spec'].invoke('slow')
end

RSpec::Core::RakeTask.new(:spec, :tag) do |t, args|
  t.rspec_opts = ["--tag #{args[:tag]}"]
end

task default: :fast_first
