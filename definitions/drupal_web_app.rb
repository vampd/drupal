#
# Cookbook Name:: apache2
# Definition:: web_app
#
# Copyright 2008-2013, Opscode, Inc.
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

define :drupal_web_app, :template => 'web_app.conf.erb', :enable => true do

  application_name = params[:name]

  web_user = node[:drupal][:server][:users][:web].split(':')

  template "#{node[:drupal][:server][:available]}/#{application_name}.conf" do
    source   params[:template]
    owner    web_user[0]
    group    web_user[1]
    mode     '0644'
    cookbook params[:cookbook] if params[:cookbook]
    variables(
      :application_name => application_name,
      :params           => params
    )
    notifies :reload, 'service[apache2]'
  end

  link "#{node[:drupal][:server][:enabled]}/#{application_name}.conf" do
    to "#{node[:drupal][:server][:available]}/#{application_name}.conf"
    notifies :reload, 'service[apache2]'
    only_if { node[:drupal][:server][:available] != node[:drupal][:server][:enabled] }
  end
end
