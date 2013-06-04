#
# Author::  Kevin Bridges (<kevin@cyberswat.com>)
# Cookbook Name:: drupal
# Recipe:: default
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

Directory "/root/.ssh" do
  action :create
  mode 0700
end

File "/root/.ssh/config" do
  action :create
  content "Host *\nStrictHostKeyChecking no"
  mode 0600
end

ruby_block "Give root access to the forwarded ssh agent" do
  block do
    # find a parent process' ssh agent socket
    agents = {}
    ppid = Process.ppid
    Dir.glob('/tmp/ssh*/agent*').each do |fn|
      agents[fn.match(/agent\.(\d+)$/)[1]] = fn
    end
    while ppid != '1'
      if (agent = agents[ppid])
        ENV['SSH_AUTH_SOCK'] = agent
        break
      end
      File.open("/proc/#{ppid}/status", "r") do |file|
        ppid = file.read().match(/PPid:\s+(\d+)/)[1]
      end
    end
    # Uncomment to require that an ssh-agent be available
    # fail "Could not find running ssh agent - Is config.ssh.forward_agent enabled in Vagrantfile?" unless ENV['SSH_AUTH_SOCK']
  end
  action :create
end

directory node[:drupal][:server][:base] do
  owner node[:drupal][:server][:web_user]
  group node[:drupal][:server][:web_group]
  mode 00755
  action :create
  recursive true
end

node[:drupal][:sites].each do |key, data|
  site_name = key
  site = data

  directory "/assets/#{site_name}" do
    owner node[:drupal][:server][:web_user]
    group node[:drupal][:server][:web_group]
    mode 00755
    action :create
  end

  link "#{node[:drupal][:server][:base]}/#{site_name}" do
    to "/assets/#{site_name}"
  end

  directory "#{node[:drupal][:server][:base]}/#{site_name}/files" do
    owner node[:drupal][:server][:web_user]
    group node[:drupal][:server][:web_group]
    mode 00755
    action :create
    recursive true
  end
  directory "#{node[:drupal][:server][:base]}/#{site_name}/shared" do
    owner node[:drupal][:server][:web_user]
    group node[:drupal][:server][:web_group]
    mode 00755
    action :create
    recursive true
  end

  if site[:deploy]
    deploy "#{node[:drupal][:server][:base]}/#{site_name}" do
      files_sorted_by_time = Dir["#{node[:drupal][:server][:base]}/#{site_name}/releases/*"].sort_by{ |f| File.mtime(f) }
      repository site[:repository][:uri]
      revision site[:repository][:revision]
      keep_releases site[:releases]

      before_migrate do
        link "#{release_path}/#{site[:files]}" do
          to "#{node[:drupal][:server][:base]}/#{site_name}/files"
          link_type :symbolic
        end

       execute "drupal-copy-settings" do
        file_index = 0
        file_index = 1 if files_sorted_by_time.length > 1
          command <<-EOF
            cp #{files_sorted_by_time[file_index]}/#{site[:settings]} #{release_path}/#{site[:settings]}
            EOF
          only_if { ::File.exists?("#{files_sorted_by_time[-2]}/#{site[:settings]}") }
        end
      end

      before_restart do

        execute "drush-site-install" do
          drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]
          install = site[:install]
          if site[:database].nil?
            cmd = "drush -y site-install #{site[:profile]}"
            install.each do |flag, value|
              cmd << " #{flag}=#{value}"
            end
            cmd << " --db-url=mysql://#{drupal_user['dbuser']}:#{drupal_user['dbpass']}@localhost/#{site_name}" if install['db-url'].nil?
            cmd << " --account-name=#{drupal_user['admin_user']}" if install['account-name'].nil?
            cmd << " --account-pass=#{drupal_user['admin_pass']}" if install['account-pass'].nil?
            cwd release_path
            command <<-EOF
              #{cmd}
            EOF
          else
            puts "beep need to tie into existing db.drush core-config sett"
          end
          not_if { files_sorted_by_time.length > 1 }
        end

        execute "drush-site-update" do
          cwd release_path
          command <<-EOF
            drush updb -y
            drush cc all
          EOF
          only_if { files_sorted_by_time.length > 1 }
        end
      end
      symlink_before_migrate.clear
      create_dirs_before_symlink.clear
      purge_before_symlink.clear
      symlinks.clear
    end
  end
end
