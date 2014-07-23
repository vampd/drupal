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
  it { should return_stdout(/drupal_db_user/) }
end

grant_select = '"SHOW GRANTS for drupal_db_user"'
describe command("#{mysql}#{grant_select}") do
  it { should return_exit_status 0 }
  it { should return_stdout(/GRANT SELECT/) }
  it { should return_stdout(/INSERT/) }
  it { should return_stdout(/UPDATE/) }
  it { should return_stdout(/DELETE/) }
  it { should return_stdout(/CREATE/) }
  it { should return_stdout(/DROP/) }
  it { should return_stdout(/INDEX/) }
  it { should return_stdout(/ALTER/) }
  it { should return_stdout(/CREATE TEMPORARY TABLES/) }
end

database_select = '"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE '
database_select << 'SCHEMA_NAME = \'example\'"'
describe command("#{mysql}#{database_select}") do
  it { should return_exit_status 0 }
  it { should return_stdout(/example/) }
end
