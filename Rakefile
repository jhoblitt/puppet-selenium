require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

PuppetSyntax.exclude_paths = ['spec/fixtures/**/*']

PuppetLint::RakeTask.new :lint do |config|
  config.pattern          = 'manifests/**/*.pp'
  config.fail_on_warnings = true
  config.disable_checks = [
    'class_inherits_from_params_class'
  ]
end

task :travis_lint do
  sh "travis-lint"
end

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = 'spec/acceptance'
end

task :default => [
  :validate,
  :lint,
  :spec,
]
