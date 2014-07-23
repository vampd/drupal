# encoding: utf-8
#
# Cookbook Name:: nmddrupal
# Recipe:: delete_mysql
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
# This is an example that installs a mysql database. If you are managing
# multiple sites you could replicate this recipe in a site specific cookbook.
include_recipe 'database::mysql'

mysql_connection_info = {
  username: 'root',
  password: node['mysql']['server_root_password']
}

mysql_database_user node['nmddrupal']['database']['username'] do
  connection mysql_connection_info
  action :drop
end

mysql_database node['nmddrupal']['database']['database'] do
  connection mysql_connection_info
  action :drop
end
