# encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'
SimpleCov.start do
  add_filter 'vendor/'
end

RSpec.configure do |config|
  config.log_level = :error
  config.color_enabled = true
  config.formatter = :documentation
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
