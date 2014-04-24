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

default[:drupal][:server][:base] = '/srv/www'
default[:drupal][:server][:assets] = '/assets'

# set drush attributes
default[:drupal][:drush][:revision] = '6.2.0'
default[:drupal][:drush][:repository] = 'https://github.com/drush-ops/drush.git'
default[:drupal][:drush][:dir] = '/opt/drush'
default[:drupal][:drush][:executable] = '/usr/bin/drush'

# set default web and files users
default[:drupal][:server][:users][:web] = 'www-data:www-data'
default[:drupal][:server][:users][:files] = node[:drupal][:server][:users][:web]

# drupal specific settings
node[:drupal][:sites].each do |site_name, site|
  default[:drupal][:sites][site_name][:active] = 0
  default[:drupal][:sites][site_name][:deploy][:action] = []
  default[:drupal][:sites][site_name][:deploy][:releases] = 5

  # default to bringing in latest drupal
  default[:drupal][:sites][site_name][:repository][:host] = 'github.com'
  default[:drupal][:sites][site_name][:repository][:uri] = 'https://github.com/drupal/drupal.git'
  default[:drupal][:sites][site_name][:repository][:revision] = '7.26'
  default[:drupal][:sites][site_name][:repository][:shallow_clone] = false

  default[:drupal][:sites][site_name][:drupal][:version] = '7.26'
  default[:drupal][:sites][site_name][:drupal][:install]['install_configure_form.update_status_module'] = "'array(FALSE,FALSE)'"
  default[:drupal][:sites][site_name][:drupal][:install]['--clean-url'] = 1

  default[:drupal][:sites][site_name][:drupal][:settings][:profile] = 'standard'
  default[:drupal][:sites][site_name][:drupal][:settings][:files] = 'sites/default/files'
  default[:drupal][:sites][site_name][:drupal][:settings][:cookbook] = 'drupal'
  default[:drupal][:sites][site_name][:drupal][:settings][:settings][:default][:location] = 'sites/default/settings.php'
  default[:drupal][:sites][site_name][:drupal][:settings][:db_name] = site_name.gsub('-', '_')
  default[:drupal][:sites][site_name][:drupal][:settings][:db_host] = 'localhost'
  default[:drupal][:sites][site_name][:drupal][:settings][:db_prefix] = ''
  default[:drupal][:sites][site_name][:drupal][:settings][:db_driver] = 'mysql'
  default[:drupal][:sites][site_name][:web_app]['80'][:server_name] = "#{site_name}.local"
  default[:drupal][:sites][site_name][:web_app]['80'][:rewrite_engine] = 'On'
  default[:drupal][:sites][site_name][:web_app]['80'][:docroot] = "#{node[:drupal][:server][:base]}/#{site_name}/current"
  default[:drupal][:sites][site_name][:web_app]['80'][:error_log] = "/var/log/apache2/#{site_name}-error.log"
end
