# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'

SimpleCov.start do
  add_filter 'vendor/'

end
RSpec.configure do |config|
  # Specify the path for Chef Solo to find cookbooks
  # config.cookbook_path = '/var/cookbooks'

  # Specify the path for Chef Solo to find roles
  # config.role_path = '/var/roles'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :error

  # Use color output for RSpec
  config.color = true

  # Use documentation output formatter
  config.formatter = :documentation
end
