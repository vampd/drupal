# encoding: utf-8
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe file('/srv/www/example/current/CHANGELOG.txt') do
  it { should be_file }
  it { should contain 'Drupal 7.28, 2014-05-08' }
end
