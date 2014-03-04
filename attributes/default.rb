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
default[:drupal][:drush][:dir] = '/opt/drush'
default[:drupal][:drush][:executable] = '/usr/bin/drush'
