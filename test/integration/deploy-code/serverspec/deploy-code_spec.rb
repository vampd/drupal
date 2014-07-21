# encoding: utf-8
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

describe file('/srv/www/example') do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
end

describe file('/srv/www/example/current/CHANGELOG.txt') do
  it { should be_file }
  it { should contain 'Drupal 7.28, 2014-05-08' }
end

describe file('/etc/ssh/ssh_known_hosts') do
  it { should be_file }
  it { should contain 'git.drupal.org' }
end
