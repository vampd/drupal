#
# Author::  Tim Whitney (tim.d.whitney@gmail.com)
# Cookbook Name:: drupal
# Recipe:: perms
#
# Copyright 2013, Tim Whitney
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

node[:drupal][:sites].each do |site_name, site|
  if site[:active]
    Chef::Log.debug("Drupal::default: after_restart: execute: /root/#{site_name}-files.sh")
    bash 'change file ownership' do
      code <<-EOH
        /root/#{site_name}-files.sh
      EOH
    end
  end
end
