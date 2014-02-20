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

# Set up the server.
Chef::Log.debug "drupal::mysql - site[:db] = #{node[:db].inspect}"
include_recipe node[:db][:client_recipe] unless node[:db][:client_recipe].nil?
include_recipe "database"
include_recipe "database::mysql"

passwords = data_bag_item('users', 'mysql')[node.chef_environment]
Chef::Log::debug "drupal::mysql passwords = #{passwords.inspect}"

if Chef::Config[:solo]
  Chef::Log.debug "drupal::mysql Setting chef solo node mysql passwords."
  node.set['mysql']['server_debian_password'] = passwords["debian"] unless passwords["debian"].nil?
  node.default[:mysql][:server_root_password] = passwords["root"] unless passwords["root"].nil?
  node.set['mysql']['server_repl_password'] = passwords["replication"] unless passwords["replication"].nil?
end

mysql_connection_info = {
  :host => node[:db][:host],
  :username => node[:db][:root],
  :password => node[:mysql][:server_root_password]
}
Chef::Log.debug "drupal::mysql - mysql_connection_info = #{mysql_connection_info.inspect}"

drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]
Chef::Log.debug "drupal::mysql - drupal_user = #{drupal_user.inspect}"

# Set up each drupal site.
Chef::Log.debug "drupal::mysql - node[:drupal] = #{node[:drupal].inspect}"

node[:drupal][:sites].each do |site_name, site|

  if site[:active]
    Chef::Log.debug "drupal::mysql site #{site_name.inspect} is active."

    if ['clean', 'update', 'import'].include?(site[:deploy][:action])

      if site[:deploy][:action] == 'clean' || site[:deploy][:action] == 'import'
        Chef::Log.debug("drupal::mysql clean install: purging database: #{site[:drupal][:settings][:db_name]}")
        mysql_database site[:drupal][:settings][:db_name] do
          connection mysql_connection_info
          action :drop
        end

        Chef::Log.debug "drupal::mysql clean install: Creating database: - `mysql -u #{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h #{mysql_connection_info[:host]} -e \"CREATE DATABASE #{site_name};\"`"
        mysql_database site[:drupal][:settings][:db_name] do
          connection mysql_connection_info
          action :create
        end
      end

      bash "Import existing #{site[:drupal][:settings][:db_name]} database." do
        only_if { site[:deploy][:action] == 'import' }
        user "root"
        mysql = "mysql -u #{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} #{site[:drupal][:settings][:db_name]} -h #{site[:drupal][:settings][:db_host]} -e "
        cmd = "#{mysql} 'SOURCE #{node[:drupal][:server][:assets]}/#{site_name}/#{site[:drupal][:settings][:db_file]}'"
        Chef::Log.debug "drupal::mysql import database: - `#{cmd}`" if site[:deploy][:action] == 'import'
        code <<-EOH
          set -x
          set -e
          #{cmd}
        EOH
      end

      node[:db][:grant_hosts].each do |host_name|
        Chef::Log.debug "drupal::mysql: - `mysql -u #{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h #{mysql_connection_info[:host]} -e \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON '#{site[:drupal][:settings][:db_name]}' TO '#{drupal_user['db_user']}'@'#{host_name}' IDENTIFIED BY '#{drupal_user['db_password']}';\"`"
        mysql_database_user drupal_user['db_user'] do
          connection mysql_connection_info
          password drupal_user['db_password']
          database_name site[:drupal][:settings][:db_name]
          host host_name
          privileges [:select,:insert,:update,:delete,:create,:drop,:index,:alter,:'lock tables',:'create temporary tables']
          action :grant
        end
      end
    end
  else
    Chef::Log.debug "drupal::mysql site #{site_name} is not active."
  end

end
