# encoding: utf-8
require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/usr/bin'
  end
end

mysql = 'mysql -u root -pilikerandompasswords -e '
user_select = '"select user from mysql.user where user = \'drupal_db_user\'"'
describe command("#{mysql}#{user_select}") do
  it { should return_exit_status 0 }
  it { should return_stdout(//) }
end

grant_select = '"SHOW GRANTS for drupal_db_user"'
describe command("#{mysql}#{grant_select}") do
  it { should return_exit_status 1 }
end
