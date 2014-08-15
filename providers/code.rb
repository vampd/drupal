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

  if /@([^:]*)/.match(new_resource.repository)
    host = /@([^:]*)/.match(new_resource.repository)[1]
  else
    host = URI.parse(new_resource.repository).host
  end
  ssh_known_hosts_entry host

  deploy new_resource.path do
    repository new_resource.repository
    revision new_resource.revision
    keep_releases new_resource.releases
    create_dirs_before_symlink new_resource.directories
    symlinks new_resource.symlinks
    symlink_before_migrate.clear
    restart_command new_resource.create.join ' && '
  end

  new_resource.updated_by_last_action(true)
end

action :delete do

  directory new_resource.path do
    action :delete
    recursive true
  end

  new_resource.updated_by_last_action(true)
end

action :update do

  deploy new_resource.path do
    repository new_resource.repository
    revision new_resource.revision
    keep_releases new_resource.releases
    create_dirs_before_symlink new_resource.directories
    symlinks new_resource.symlinks
    symlink_before_migrate.clear
    restart_command new_resource.update.join ' && '
  end

  new_resource.updated_by_last_action(true)
end

action :sleep do
end
