source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'rake',                   :require => false
gem 'puppetlabs_spec_helper', :require => false
gem 'puppet-lint',            :require => false
gem 'puppet-syntax',          :require => false
gem 'rspec-puppet',
  :git => 'https://github.com/rodjek/rspec-puppet.git',
  :ref => '6ac97993fa972a15851a73d55fe3d1c0a85172b5',
  :require => false
# rspec 3 spews warnings with rspec-puppet 1.0.1
# gem 'rspec-core', '~> 2.0',   :require => false
gem 'beaker',                  :require => false
gem 'beaker-rspec',            :require => false
gem 'serverspec',              :require => false
gem 'pry',                     :require => false
