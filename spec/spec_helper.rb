# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'
Coveralls.wear!
RSpec.configure do |config|

  # Specify the Chef log_level (default: :warn)
  config.log_level = :error

  # Use color output for RSpec
  config.color_enabled = true

  # Use documentation output formatter
  config.formatter = :documentation
end
