# encoding: utf-8
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe command('which drush') do
  it { should return_exit_status 0 }
  it { should return_stdout '/usr/bin/drush' }
end
