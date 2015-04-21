#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Author:: Alex Knoll (arknoll@gmail.com)
# Cookbook Name:: drupal
# Recipe:: mysql
#
# Copyright 2013, Cyberswat Industries, LLC.
# Copyright 2015, Alex Knoll
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
passwords = data_bag_item('users', 'mysql')[node.chef_environment]

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default' do
  version '5.5'
  bind_address '0.0.0.0'
  port '3306'
  data_dir '/data'
  initial_root_password passwords['root']
  action [:create, :start]
end

mysql_config 'default' do
  source 'my.cnf.erb'
  instance 'default'
  variables({
    :tunable => node[:mysql][:tunable]
  })
  notifies :restart, 'mysql_service[default]'
  action :create
end

mysql_client 'default' do
  action :create
end

mysql_connection_info = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => passwords['root'],
  :port => '3306'
}

drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]

# Set up each drupal site.
node[:drupal][:sites].each do |site_name, site|

  if site[:active]
    if site[:deploy][:action].any? { |action| %w[install import].include? action }
      mysql_database site[:drupal][:settings][:db_name] do
        connection mysql_connection_info
        action :drop
      end

      Chef::Log.debug "drupal::mysql clean install: Creating database: - `mysql -u #{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h #{mysql_connection_info[:host]} -e \"CREATE DATABASE #{site_name};\"`"
      mysql_database site[:drupal][:settings][:db_name] do
        connection mysql_connection_info
        action :create
      end

      bash "Import existing #{site[:drupal][:settings][:db_name]} database." do
        only_if { site[:deploy][:action].any? { |action| action == 'import' } }
        user 'root'
        mysql = "mysql -u #{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} #{site[:drupal][:settings][:db_name]} -h #{site[:drupal][:settings][:db_host]} -e "
        cmd = "#{mysql} 'SOURCE #{site[:drupal][:settings][:db_file]}'"
        Chef::Log.debug "drupal::mysql import database: - `#{cmd}`" if site[:deploy][:action].any? { |action| action == 'import' }
        code <<-EOH
          set -x
          set -e
          #{cmd}
        EOH
      end

      # Run post-import scripts if any are defined.
      if site[:deploy][:action].any? { |action| action == 'import' } && site[:deploy][:scripts][:post_import].any?
        site[:deploy][:scripts][:post_import].each do |script|
          bash "Run post-import script #{script} for #{site_name}" do
            cwd "#{node[:drupal][:server][:base]}/#{site_name}/current"
            user 'root'
            cmd = "sh #{script}"
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end
        end
      end

      node[:db][:grant_hosts].each do |host_name|
        Chef::Log.debug "drupal::mysql: - `mysql -u #{mysql_connection_info[:username]} -p#{mysql_connection_info[:password]} -h #{mysql_connection_info[:host]} -e \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES, CREATE TEMPORARY TABLES ON '#{site[:drupal][:settings][:db_name]}' TO '#{drupal_user['db_user']}'@'#{host_name}' IDENTIFIED BY '#{drupal_user['db_password']}';\"`"
        mysql_database_user drupal_user['db_user'] do
          connection mysql_connection_info
          password drupal_user['db_password']
          database_name site[:drupal][:settings][:db_name]
          host host_name
          privileges [:select, :insert, :update, :delete, :create, :drop, :index, :alter, :'lock tables', :'create temporary tables']
          action :grant
        end
      end
    end
  end
end
