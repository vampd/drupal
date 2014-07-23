#
# Cookbook Name:: nmddrupal
# Resource:: code
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

actions :create, :delete
default_action :create

attribute :path, kind_of: String, name_attribute: true
attribute :owner, kind_of: String
attribute :group, kind_of: String
attribute :mode, kind_of: Fixnum, default: 00755
repository_string = 'https://github.com/drush-ops/drush.git'
attribute :repository, kind_of: String, default: repository_string
attribute :revision, kind_of: String, default: '6.3.0'
attribute :releases, kind_of: Fixnum, default: 5
attribute :executable, kind_of: String, default: '/usr/bin/drush'

def initialize(*args)
  super
  @action = :create
end
