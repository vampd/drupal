# encoding: utf-8
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

actions :create, :delete, :update, :sleep
default_action :create

attribute :path, kind_of: String, name_attribute: true
attribute :owner, kind_of: String
attribute :group, kind_of: String
attribute :mode, kind_of: Fixnum, default: 00755
repository_string = 'http://git.drupal.org/project/drupal.git'
attribute :repository, kind_of: String, default: repository_string
attribute :revision, kind_of: String, default: '7.x'
attribute :releases, kind_of: Fixnum, default: 5
attribute :directories, kind_of: Array, default: ['sites/all', 'sites/default']
attribute :symlinks, kind_of: Hash, default: { 'files' => 'sites/default/files' }
attribute :before_update, kind_of: Array
attribute :update, kind_of: Array
attribute :create, kind_of: Array

def initialize(*args)
  super
  @action = :create
end
