# encoding: utf-8
require 'serverspec' # rubocop:disable Style/FileName

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

# This makes sure that the www directory was created during a deploy-code.
describe file('/srv/www') do
  it { should be_directory }
end

describe command('ls /srv/www/example') do
  it { should return_exit_status 2  }
end
