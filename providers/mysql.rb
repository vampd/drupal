# encoding: utf-8
#
# Cookbook Name:: drupal
# Provider:: mysql
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
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :create do

  connection_info = {
    host: new_resource.host,
    username: new_resource.create_username,
    password: new_resource.create_password
  }

  mysql_database new_resource.database do
    connection connection_info
    action :create
  end

  mysql_database_user new_resource.username do
    connection connection_info
    password new_resource.password
    action :create
  end

  mysql_database_user new_resource.username do
    connection connection_info
    password new_resource.password
    database_name new_resource.database
    host '%'
    privileges [
      :select,
      :insert,
      :update,
      :delete,
      :create,
      :drop,
      :index,
      :alter,
      :'create temporary tables'
    ]
    action :grant
  end

  new_resource.updated_by_last_action(true)
end

action :delete do

  connection_info = {
    host: new_resource.host,
    username: new_resource.create_username,
    password: new_resource.create_password
  }
  mysql_database_user new_resource.username do
    connection connection_info
    action :drop
  end

  mysql_database new_resource.database do
    connection connection_info
    action :drop
  end

  new_resource.updated_by_last_action(true)
end

action :update do
end
action :sleep do
end
