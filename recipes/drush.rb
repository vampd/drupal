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
directory node['nmddrupal']['drush']['dir'] do
  owner node['nmddrupal']['drush']['owner']
  group node['nmddrupal']['drush']['group']
  mode node['nmddrupal']['drush']['mode']
  action :create
  recursive true
  not_if { ::File.directory?(node['nmddrupal']['drush']['dir']) }
  only_if { node['nmddrupal']['drush']['state'] == 'install' }
end

directory "#{node['nmddrupal']['drush']['dir']}/shared" do
  owner node['nmddrupal']['drush']['owner']
  group node['nmddrupal']['drush']['group']
  mode node['nmddrupal']['drush']['mode']
  action :create
  not_if { ::File.directory?("#{node['nmddrupal']['drush']['dir']}/shared") }
  only_if { node['nmddrupal']['drush']['state'] == 'install' }
end

deploy node['nmddrupal']['drush']['dir'] do
  repository node['nmddrupal']['drush']['repository']
  revision node['nmddrupal']['drush']['revision']
  keep_releases 1
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  only_if node['nmddrupal']['drush']['state'].match('install,update')
end

link node['nmddrupal']['drush']['executable'] do
  to "#{node['nmddrupal']['drush']['dir']}/current/drush"
  link_type :symbolic
  not_if { ::File.exist?(node['nmddrupal']['drush']['executable']) }
  only_if { node['nmddrupal']['drush']['state'] == 'install' }
end

ruby_block 'evaluate drush state' do
  block do
    unless node['nmddrupal']['drush']['state'].match(/ed$/)
      node.set['nmddrupal']['drush']['state'] =
        "#{node['nmddrupal']['drush']['state']}ed"
      node.save unless Chef::Config[:solo]
    end
  end
end
