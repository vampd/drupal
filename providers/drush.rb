# encoding: utf-8
#
# Cookbook Name:: drupal
# Provider:: code
#
# Author:: NEWMEDIA Denver
# Copyright:: 2014, NEWMEDIA Denver
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
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do

  directory new_resource.path do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    action :create
    recursive true
  end

  directory '/etc/drush' do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    action :create
    recursive true
  end

  ssh_known_hosts_entry URI.parse(new_resource.repository).host

  deploy new_resource.path do
    repository new_resource.repository
    revision new_resource.revision
    keep_releases new_resource.releases
    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear
  end

  link new_resource.executable do
    to "#{new_resource.path}/current/drush"
    link_type :symbolic
  end

  new_resource.updated_by_last_action(true)
end

action :delete do

  directory new_resource.path do
    action :delete
    recursive true
  end

  link new_resource.executable do
    action :delete
  end

  new_resource.updated_by_last_action(true)
end
