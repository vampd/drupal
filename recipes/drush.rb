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
end

directory "#{node[:drupal][:drush][:dir]}/shared" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::File.directory?("#{node[:drupal][:drush][:dir]}/shared") }
end

deploy node[:drupal][:drush][:dir] do
  repository node[:drupal][:drush][:repository]
  revision node[:drupal][:drush][:revision]
  keep_releases 1
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end

link node[:drupal][:drush][:executable] do
  to "#{node[:drupal][:drush][:dir]}/current/drush"
  link_type :symbolic
  #not_if "test -h #{node[:drupal][:drush][:executable]}"
end
