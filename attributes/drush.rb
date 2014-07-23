# encoding: utf-8
#
# Cookbook Name:: nmddrupal
# Attributes:: files
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

default['nmddrupal']['drush']['revision'] = '6.3.0'
default['nmddrupal']['drush']['repository'] =
  'https://github.com/drush-ops/drush.git'
default['nmddrupal']['drush']['path'] = '/opt/drush'
default['nmddrupal']['drush']['executable'] = '/usr/bin/drush'
default['nmddrupal']['drush']['owner'] = 'root'
default['nmddrupal']['drush']['group'] = 'root'
default['nmddrupal']['drush']['mode'] = 00755
