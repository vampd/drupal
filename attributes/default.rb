#
# Author:: Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Attribute:: default
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

default[:drupal][:sites] = {}

default[:drupal][:server][:web_user] = 'www-data'
default[:drupal][:server][:web_group] = 'www-data'
default[:drupal][:server][:base] = '/srv/www'
default[:drupal][:server][:assets] = '/assets'

default[:drupal][:drush][:revision] = '6.2.0'
default[:drupal][:drush][:repository] = 'https://github.com/drush-ops/drush.git'
default[:drupal][:drush][:dir] = '/usr/local/src/drush'
default[:drupal][:drush][:executable] = '/usr/bin/drush'

# set default web and files users
default[:drupal][:server][:users][:web] = 'www-data:www-data'
default[:drupal][:server][:users][:files] = node[:drupal][:server][:users][:web]

# drupal specific settings
node[:drupal][:sites].each do |site_name, site|
  default[:drupal][:sites][site_name][:active] = 0
  default[:drupal][:sites][site_name][:deploy][:action] = []
  default[:drupal][:sites][site_name][:deploy][:releases] = 5
  default[:drupal][:sites][site_name][:deploy][:scripts][:post_deploy] = []
  default[:drupal][:sites][site_name][:deploy][:scripts][:post_install] = []
  default[:drupal][:sites][site_name][:deploy][:scripts][:post_import] = []
  default[:drupal][:sites][site_name][:deploy][:scripts][:post_update] = []
  default[:drupal][:sites][site_name][:deploy][:scripts][:post_everything] = []

  # default to bringing in latest drupal
  default[:drupal][:sites][site_name][:repository][:host] = 'github.com'
  default[:drupal][:sites][site_name][:repository][:uri] = 'https://github.com/drupal/drupal.git'
  default[:drupal][:sites][site_name][:repository][:revision] = '7.36'
  default[:drupal][:sites][site_name][:repository][:shallow_clone] = false
  default[:drupal][:sites][site_name][:repository][:submodule] = false

  default[:drupal][:sites][site_name][:drupal][:version] = '7.x'
  default[:drupal][:sites][site_name][:drupal][:registry_rebuild] = false
  default[:drupal][:sites][site_name][:drupal][:install]['install_configure_form.update_status_module'] = "'array(FALSE,FALSE)'"
  default[:drupal][:sites][site_name][:drupal][:install]['--clean-url'] = 1

  #Set up the docroot to be used as a default
  default[:drupal][:sites][site_name][:drupal][:settings][:docroot] = ''
  docroot_before = ''
  docoot_after = ''
  if node[:drupal][:sites][site_name][:drupal][:settings][:docroot].to_s != ''
    docroot = node[:drupal][:sites][site_name][:drupal][:settings][:docroot]
    docroot_before = "#{docroot}/"
    docoot_after = "/#{docroot}"
  end

  default[:drupal][:sites][site_name][:drupal][:settings][:profile] = 'standard'
  default[:drupal][:sites][site_name][:drupal][:settings][:files] = "#{docroot_before}sites/default/files"
  default[:drupal][:sites][site_name][:drupal][:settings][:cookbook] = 'drupal'
  default[:drupal][:sites][site_name][:drupal][:settings][:settings][:default][:location] = "#{docroot_before}sites/default/settings.php"
  default[:drupal][:sites][site_name][:drupal][:settings][:settings][:default][:ignore] = false
  default[:drupal][:sites][site_name][:drupal][:settings][:db_name] = site_name.gsub('-', '_')
  default[:drupal][:sites][site_name][:drupal][:settings][:db_host] = '127.0.0.1'
  default[:drupal][:sites][site_name][:drupal][:settings][:db_port] = '3306'
  default[:drupal][:sites][site_name][:drupal][:settings][:db_prefix] = ''
  default[:drupal][:sites][site_name][:drupal][:settings][:db_driver] = 'mysql'

  directory = "#{node[:drupal][:server][:base]}/#{site_name}/current#{docoot_after}"
  default[:drupal][:sites][site_name][:web_app]['80'][:server_name] = "#{site_name}.local"
  default[:drupal][:sites][site_name][:web_app]['80'][:rewrite_engine] = 'On'
  default[:drupal][:sites][site_name][:web_app]['80'][:docroot] = directory
  default[:drupal][:sites][site_name][:web_app]['80'][:error_log] = "/var/log/apache2/#{site_name}-error.log"

  if node['apache']['version'] == '2.4'
    default[:drupal][:sites][site_name][:web_app]['80'][:directories][directory][:options] = ['Indexes', 'FollowSymLinks', 'MultiViews']
    default[:drupal][:sites][site_name][:web_app]['80'][:directories][directory][:allow_override] = ['All']
    default[:drupal][:sites][site_name][:web_app]['80'][:directories][directory][:require] = ['all', 'granted']
  end

  default[:drupal][:sites][site_name][:drupal_user][:id] = site_name
  default[:drupal][:sites][site_name][:drupal_user][:db_user] = 'drupal'
  default[:drupal][:sites][site_name][:drupal_user][:db_password] = 'drupal'
  default[:drupal][:sites][site_name][:drupal_user][:admin_user] = 'admin'
  default[:drupal][:sites][site_name][:drupal_user][:admin_pass] = 'admin'
  default[:drupal][:sites][site_name][:drupal_user][:update_password] = false
end

# This is necessary until https://github.com/opscode-cookbooks/php/pull/107
# Is pulled into a release.
case node['platform']
  when 'ubuntu'
    if node['platform_version'].to_f >= 12.10
      default['php']['ext_conf_dir'] = '/etc/php5/mods-available'
    else
      default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
    end
  else
    default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
end
