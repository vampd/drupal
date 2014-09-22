#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Recipe:: apache
#
# Copyright 2013, Cyberswat Industries, LLC.
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
service 'apache2' do
  case node[:platform]
  when 'redhat', 'centos', 'scientific', 'fedora', 'suse', 'amazon', 'oracle'
    service_name 'httpd'
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command '/sbin/service httpd restart && sleep 1'
    reload_command '/sbin/service httpd reload && sleep 1'
  when 'debian', 'ubuntu'
    service_name 'apache2'
    restart_command '/usr/sbin/invoke-rc.d apache2 restart && sleep 1'
    reload_command '/usr/sbin/invoke-rc.d apache2 reload && sleep 1'
  when 'arch'
    service_name 'httpd'
  when 'freebsd'
    service_name 'apache22'
  end
  supports [:restart, :reload, :status]
  action :enable
end

node[:drupal][:sites].each do |site_name, site|
  if site[:active]
    site['web_app'].each do |port, app|

      # Remove virtualhost settings if action = remove
      file "#{node[:drupal][:server][:available]}/#{site_name}-#{port}.conf" do
        action :delete
        only_if { site[:deploy][:action].any? { |action| action == 'remove' } }
        notifies :reload, 'service[apache2]'
      end

      file "#{node[:drupal][:server][:enabled]}/#{site_name}-#{port}.conf" do
        action :delete
        only_if { site[:deploy][:action].any? { |action| action == 'remove' } }
        notifies :reload, 'service[apache2]'
      end

      drupal_web_app "#{site_name}-#{port}" do
        port port
        docroot app['docroot'] unless app['docroot'].nil?
        server_name app['server_name'] unless app['server_name'].nil?
        server_aliases app['server_aliases'] unless app['server_aliases'].nil?
        rewrite_engine app['rewrite_engine'] unless app['rewrite_engine'].nil?
        rewrite_log app['rewrite_log'] unless app['rewrite_log'].nil?
        rewrite_log_level app['rewrite_log_level'] unless app['rewrite_log_level'].nil?
        directories app['directories'] unless app['directories'].nil?
        rewrite app['rewrite'] unless app['rewrite'].nil?
        log_level app['log_level'] unless app['log_level'].nil?
        error_log app['error_log'] unless app['error_log'].nil?
        custom_log app['custom_log'] unless app['custom_log'].nil?
        transfer_log app['transfer_log'] unless app['transfer_log'].nil?
        set_env_if app['set_env_if'] unless app['set_env_if'].nil?
        redirect app['redirect'] unless app['redirect'].nil?
        unless app['ssl'].nil?
          ssl_engine app['ssl']['ssl_engine'] unless app['ssl']['ssl_engine'].nil?
          ssl_protocol app['ssl']['ssl_protocol'] unless app['ssl']['ssl_protocol'].nil?
          ssl_cipher_suite app['ssl']['ssl_cipher_suite'] unless app['ssl']['ssl_cipher_suite'].nil?
          ssl_certificate_file app['ssl']['ssl_certificate_file'] unless app['ssl']['ssl_certificate_file'].nil?
          ssl_certificate_key_file app['ssl']['ssl_certificate_key_file'] unless app['ssl']['ssl_certificate_key_file'].nil?
          ssl_certificate_chain_file app['ssl']['ssl_certificate_chain_file'] unless app['ssl']['ssl_certificate_chain_file'].nil?
        end
      end
    end
  end
end
