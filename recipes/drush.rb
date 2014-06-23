# encoding: utf-8
#
# Author:: NEWMEDIA Denver
# Email:: support@newmediadenver.com
#
# Cookbook Name:: nmd-drupal
# Recipe:: files
#
# Copyright:: 2014, newmedia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
directory node[:drupal][:drush][:dir] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
  not_if { ::File.directory?(node[:drupal][:drush][:dir]) }
  only_if { node[:drupal][:drush][:state] == 'install' }
end

directory "#{node[:drupal][:drush][:dir]}/shared" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::File.directory?("#{node[:drupal][:drush][:dir]}/shared") }
  only_if { node[:drupal][:drush][:state] == 'install' }
end

deploy node[:drupal][:drush][:dir] do
  repository node[:drupal][:drush][:repository]
  revision node[:drupal][:drush][:revision]
  keep_releases 1
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  # rubocop:disable WordArray
  only_if { ['install', 'update'].include?(node[:drupal][:drush][:state]) }
  # rubocop:enable WordArray
end

link node[:drupal][:drush][:executable] do
  to "#{node[:drupal][:drush][:dir]}/current/drush"
  link_type :symbolic
  not_if { ::File.exist?(node[:drupal][:drush][:executable]) }
  only_if { node[:drupal][:drush][:state] == 'install' }
end

ruby_block 'evaluate drush state' do
  block do
    unless node[:drupal][:drush][:state].match(/ed$/)
      node.set[:drupal][:drush][:state] = "#{node[:drupal][:drush][:state]}ed"
      node.save unless Chef::Config[:solo]
    end
  end
end
