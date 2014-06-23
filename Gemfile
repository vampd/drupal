# encoding: utf-8
source 'https://rubygems.org'

gem 'berkshelf', '= 3.1.3'

group :test, :development do
  gem 'foodcritic', '= 3.0.3'
  gem 'rake', '= 10.3.2'
  gem 'rubocop', '>= 0.23.0'
  gem 'rspec', '= 2.14.1'
  gem 'chefspec', '= 3.4.0'
  gem 'travis', '= 1.6.14'
  gem 'coveralls', require: false
  gem 'fauxhai', '= 2.1.2'
  gem 'websocket-native', '= 1.0.0'
  gem 'octokit', '= 3.1.2'
  gem 'simplecov'
end

group :integration do
  gem 'test-kitchen', '= 1.2.1'
  gem 'kitchen-vagrant'
  gem 'vagrant-wrapper'
end
