source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

group :development, :test do
  gem 'rake'
  gem 'puppetlabs_spec_helper'
  gem 'puppet-lint'
  gem 'puppet-syntax'
end

group :system do
  gem 'rspec-system'
  gem 'rspec-system-puppet'
  gem 'rspec-system-serverspec'
  gem 'serverspec'
end

# vim:ft=ruby
