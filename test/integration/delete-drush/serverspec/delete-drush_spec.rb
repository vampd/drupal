# encoding: utf-8
require 'serverspec' # rubocop:disable Style/FileName

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe command('ls /opt/drush') do
  it { should return_exit_status 2 }
end
describe command('which drush') do
  it { should return_exit_status 1 }
end
