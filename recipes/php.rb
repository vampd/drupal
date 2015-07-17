#
# Author::  Alex Knoll (arknoll@gmail.com)
# Cookbook Name:: drupal
# Recipe:: php
#
# Copyright 2015, Alex Knoll
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

ruby_block 'check_php_version' do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    command = 'php -v'
    command_out = shell_out(command)
    if command_out.stdout.include? 'PHP 5.3'
      # For php 5.3 include apc.
      node.set[:drupal][:php][:version] = '5.3'
    end
  end
  action :create
  notifies :install, "php_pear[apc]", :immediately
end

# Install apc pecl with directives.
php_pear 'apc' do
  action :nothing
  directives(:shm_size => '96M', :enable_cli => 1)
  only_if { node[:drupal][:php] == '5.3' }
end

php_pear 'uploadprogress' do
  action :install
end
