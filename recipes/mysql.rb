#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Recipe:: mysql
#
# Copyright 2013, Cyberswat Industries, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
passwords = data_bag_item('users', 'mysql')[node.chef_environment]
node.set['mysql']['server_root_password'] = passwords["root"]
node.set['mysql']['server_repl_password'] = passwords["replication"]
node.set['mysql']['server_debian_password'] = passwords["debian"]

include_recipe "mysql::server"
include_recipe "mysql::client"
include_recipe "database"
include_recipe "database::mysql"

mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]
node[:drupal][:sites].each do |data|
  site_name = data.keys.first
  site = data[site_name]
  mysql_database site_name do
    connection mysql_connection_info
    action :create
  end

  ['%', 'localhost'].each do |host_name|
    mysql_database_user drupal_user['dbuser'] do
      connection mysql_connection_info
      password drupal_user['dbpass']
      database_name site_name
      host host_name
      privileges [:select,:insert,:update,:delete,:create,:drop,:index,:alter,:'lock tables',:'create temporary tables']
      action :grant
    end
  end

  unless site[:database].nil?
=begin
I should be able to use something like the following but it simply doesn't work
in chef:

    mysql_database site_name do
      connection mysql_connection_info
      sql "SOURCE #{node[:drupal][:server][:assets]}/#{site_name}/#{site[:database]}"
      action :query
    end

Instead, I have to go the dirty route and do the following in bash.  If you can
help resolve this please do so that I don't feel dirty!
=end
    bash "Import existing #{site_name} database." do
      user "root"
      code <<-EOH
        ret=$(mysql -u root -p#{passwords['root']} --disable-column-names -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '#{site_name}'")
        if [ $ret -eq 0 ]
          then mysql -u root -p#{passwords['root']} #{site_name} -e 'SOURCE /assets/#{site_name}/#{site[:database]}'
        fi
      EOH
    end

  end
end
