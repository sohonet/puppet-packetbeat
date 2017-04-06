source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['~> 4.0']
gem 'puppet', puppetversion

gem 'facter', '>= 1.7.0', require: false
gem 'json_pure', '<= 2.0.1', require: false if RUBY_VERSION < '2.0.0'
gem 'metadata-json-lint', require: false
gem 'mocha', '>= 1.2.1', require: false
gem 'puppet-lint', '>= 1.0.0', require: false
gem 'puppet-lint-absolute_classname-check', require: false
gem 'puppet-lint-classes_and_types_beginning_with_digits-check', require: false
gem 'puppet-lint-leading_zero-check', require: false
gem 'puppet-lint-trailing_comma-check', require: false
gem 'puppet-lint-unquoted_string-check', require: false
gem 'puppet-lint-variable_contains_upcase', require: false
gem 'puppet-lint-version_comparison-check', require: false
gem 'puppet-strings', '~> 0.99.0', require: false
gem 'puppetlabs_spec_helper', '>= 1.0.0', require: false
gem 'rspec-puppet', require: false
gem 'rspec-puppet-facts', require: false
gem 'rspec-puppet-utils', require: false
gem 'rubocop-rspec', require: false
gem 'voxpupuli-release', require: false, git: 'https://github.com/voxpupuli/voxpupuli-release-gem.git'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
  gem 'rake', '~> 10.0'
  gem 'rspec', '~> 2.0'
else
  # rubocop requires ruby >= 1.9
  gem 'rubocop'
end
