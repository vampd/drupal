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

node[:drupal][:sites].each do |site_name, site|

  if site[:active]

    drupal_user = data_bag_item('sites', site_name)[node.chef_environment]
    Chef::Log.debug "drupal::mysql - drupal_user = #{drupal_user.inspect}"

    # Set up each drupal site.
    Chef::Log.debug "drupal::mysql - node[:drupal] = #{node[:drupal].inspect}"
    Chef::Log.debug "drupal::mysql site #{site_name} is active."

    if site[:deploy][:action].any? { |action| %w(install import).include? action }

      Chef::Log.debug("drupal::mysql clean install: purging database: #{site[:drupal][:settings][:db_name]}")
      bash "Drop database #{site[:drupal][:settings][:db_name]}." do
        user 'root'
        mysql = "mysql -u #{drupal_user[:mysql][:maintenance_user]} -p#{drupal_user[:mysql][:maintenance_password]} -h #{site[:drupal][:settings][:db_host]}"
        cmd = "#{mysql} -e 'DROP DATABASE IF EXISTS #{site[:drupal][:settings][:db_name]}'"
        Chef::Log.debug "drupal::mysql drop database: - `#{cmd}`"
        code <<-EOH
          set -x
          set -e
          #{cmd}
        EOH
      end

      Chef::Log.debug "drupal::mysql clean install: Creating database #{site_name}"
      bash "Create #{site[:drupal][:settings][:db_name]} database." do
        user 'root'
        mysql = "mysql -u #{drupal_user[:mysql][:maintenance_user]} -p#{drupal_user[:mysql][:maintenance_password]} -h #{site[:drupal][:settings][:db_host]}"
        cmd = "#{mysql} -e 'CREATE DATABASE #{site[:drupal][:settings][:db_name]}'"
        Chef::Log.debug "drupal::mysql create database: - `#{cmd}`"
        code <<-EOH
          set -x
          set -e
          #{cmd}
        EOH
      end

      bash "Import existing #{site[:drupal][:settings][:db_name]} database." do
        only_if { site[:deploy][:action].any? { |action| action == 'import' } }
        user 'root'
        mysql = "mysql -u #{drupal_user[:mysql][:maintenance_user]} -p#{drupal_user[:mysql][:maintenance_password]} #{site[:drupal][:settings][:db_name]} -h #{site[:drupal][:settings][:db_host]} -e "
        cmd = "#{mysql} 'SOURCE #{site[:drupal][:settings][:db_file]}'"
        Chef::Log.debug "drupal::mysql import database: - `#{cmd}`" if site[:deploy][:action].any? { |action| action == 'import' }
        code <<-EOH
          set -x
          set -e
          #{cmd}
        EOH
      end
    end

    bash "Drop #{site[:drupal][:settings][:db_name]} database." do
      only_if { site[:deploy][:action].any? { |action| action == 'remove' } }
      user 'root'
      mysql = "mysql -u #{drupal_user[:mysql][:maintenance_user]} -p#{drupal_user[:mysql][:maintenance_password]} -h #{site[:drupal][:settings][:db_host]}"
      cmd = "#{mysql} -e 'DROP DATABASE IF EXISTS #{site[:drupal][:settings][:db_name]}'"
      Chef::Log.debug "drupal::mysql drop database: - `#{cmd}`"
      code <<-EOH
        set -x
        set -e
        #{cmd}
      EOH
    end
  else
    Chef::Log.debug "drupal::mysql site #{site_name} is not active."
  end
end
