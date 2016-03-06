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
end

namespace :travis do
  desc "Syntax check travis.yml"
  task :lint do
    # warnings are currently non-fatal due to suspected problems with
    # validation of matrix::include
    #sh "travis lint --exit-code" do |ok, res|
    sh "travis lint" do |ok, res|
      unless ok
        # exit without verbose rake error message
        exit res.exitstatus
      end
    end
  end
end

task :default => [
  'travis:lint',
  :validate,
  :lint,
  :spec,
]
