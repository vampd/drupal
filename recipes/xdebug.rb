#
# Cookbook Name:: drupal
# Recipe:: xdebug
#
# Copyright (C) 2014 Alex Knoll <arknoll@gmail.com>
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

php_pear "xdebug" do
  action :install
end

file "/etc/php5/conf.d/xdebug.ini" do
  action :delete
  notifies :restart, "service[apache2]", :delayed
  only_if { File.exists?("/etc/php5/conf.d/xdebug.ini") }
end

template "/etc/php5/conf.d/xdebug.ini" do
  source "xdebug.ini.erb"
  mode "0644"
  notifies :restart, "service[apache2]", :delayed
end
