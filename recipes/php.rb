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
include_recipe 'php'

['php5-mysql', 'php5-gd', 'php5-curl', 'libpcre3-dev'].each do |pkg|
  package pkg do
    action :install
  end
end

# install apc pecl with directives.
php_pear "apc" do
  action :install
  directives(:shm_size => '96M', :enable_cli => 1)
end

php_pear 'uploadprogress' do
  action :install
end
