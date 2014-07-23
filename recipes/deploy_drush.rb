# encoding: utf-8
#
# Cookbook Name:: nmddrupal
# Recipe:: deploy_drush
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

include_recipe 'git::default'

# This example uses each of the exposed attributes.
nmddrupal_drush node[:nmddrupal][:drush][:path] do
  owner node[:nmddrupal][:drush][:owner]
  group node[:nmddrupal][:drush][:group]
  mode node[:nmddrupal][:drush][:mode]
  repository node[:nmddrupal][:drush][:repository]
  revision node[:nmddrupal][:drush][:revision]
  releases node[:nmddrupal][:drush][:releases]
  executable node[:nmddrupal][:drush][:executable]
end
