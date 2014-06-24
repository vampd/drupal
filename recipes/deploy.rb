#
# Cookbook Name:: nmddrupal
# Recipe:: deploy
#
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
web_user = node[:nmddrupal][:server][:users][:web].split(':')

directory node[:nmddrupal][:server][:base] do
  owner web_user[0]
  group web_user[1]
  mode 00755
  action :create
  recursive true
  not_if { ::File.exist?(node[:nmddrupal][:server][:base]) }
end

node[:nmddrupal][:sites].each do |name, site|

  ssh_known_hosts_entry site[:repository][:host]

  # deploy only if deploy action present
  deploy "#{node[:nmddrupal][:server][:base]}/#{name}" do
    only_if { site[:deploy][:action].any? { |action| action == 'deploy' } }
    repository site[:repository][:uri]
    revision site[:repository][:revision]
    keep_releases site[:deploy][:releases]
    shallow_clone site[:repository][:shallow_clone]

    symlink_before_migrate.clear
    create_dirs_before_symlink.clear
    purge_before_symlink.clear
    symlinks.clear
  end
end
