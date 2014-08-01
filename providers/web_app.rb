# encoding: utf-8
#
# Cookbook Name:: apache2
# Providers:: web_app
#
# Copyright 2012-2014, Opscode, Inc.
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
  template new_resource.name do
    group new_resource.group
    mode new_resource.mode
    owner new_resource.owner
    source new_resource.source
    cookbook new_resource.cookbook
    variables new_resource.variables
  end

  new_resource.updated_by_last_action(true)
end

action :delete do

  directory new_resource.path do
    action :delete
    recursive false
  end

  new_resource.updated_by_last_action(true)
end
