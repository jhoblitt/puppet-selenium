source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'semantic_puppet'

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', '=2.4.6', :require => false
end

group :development, :test do
  gem 'rake', '~> 11.2.2',                    :require => false
  # https://github.com/rspec/rspec-core/issues/1864
  gem 'rspec', '< 3.2.0', {"platforms"=>["ruby_18"]}
  gem 'puppetlabs_spec_helper', '= 1.1.1',   :require => false
  gem 'puppet-lint', '>= 1.1.0',  :require => false
  gem 'puppet-syntax',            :require => false
  gem 'rspec-puppet', '~> 2.2',   :require => false
  gem 'metadata-json-lint','=0.0.11',       :require => false
  gem 'json', '=1.8.3', :platforms => 'ruby_18'
  gem 'json_pure', '=1.8.3', :platforms => 'ruby_18'
end

group :beaker do
  gem 'serverspec',               :require => false
  gem 'beaker', '=2.49.0',                  :require => false
  gem 'beaker-rspec',             :require => false
  gem 'pry',                      :require => false
  gem 'travis-lint',              :require => false
  gem 'puppet-blacksmith',        :require => false
end

# vim:ft=ruby

# Installing rake 11.2.2
# Installing CFPropertyList 2.2.8
# Installing diff-lcs 1.2.5
# Installing facter 2.4.6
# Installing json_pure 1.8.3
# Installing hiera 1.3.4
# Installing json 1.8.3
# Installing metaclass 0.0.4
# Installing spdx-licenses 1.1.0
# Installing metadata-json-lint 0.0.11
# Installing mocha 1.1.0
# Installing puppet 3.8.7
# Installing puppet-lint 2.0.2
# Installing puppet-syntax 2.1.0
# Installing rspec-support 3.1.2
# Installing rspec-core 3.1.7
# Installing rspec-expectations 3.1.2
# Installing rspec-mocks 3.1.3
# Installing rspec 3.1.0
# Installing rspec-puppet 2.4.0
# Installing puppetlabs_spec_helper 1.1.1