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

    if site[:clean]
      execute "drupal-clean-releases" do
        cmd = "rm -rf #{node[:drupal][:server][:base]}/#{site_name}/releases"
        Chef::Log.debug("Clean install: #{cmd}") if ::File.exists?("#{node[:drupal][:server][:base]}/#{site_name}/releases")
        command <<-EOF
          #{cmd}
          EOF
        only_if { ::File.exists?("#{node[:drupal][:server][:base]}/#{site_name}/releases") }
      end
    end

    deploy "#{node[:drupal][:server][:base]}/#{site_name}" do
      files_sorted_by_time = Dir["#{node[:drupal][:server][:base]}/#{site_name}/releases/*"].sort_by{ |f| File.mtime(f) }
      files_sorted_by_time = [] if site[:clean]
      file_index = 0
      file_index = 1 if files_sorted_by_time.length > 1
      settings_file = "#{files_sorted_by_time[file_index]}/#{site[:settings]}"

      Chef::Log.debug "drupal deploy: files_sorted_by_time = #{files_sorted_by_time.inspect} #{files_sorted_by_time.length}"
      repository site[:repository][:uri]
      revision site[:repository][:revision]
      keep_releases site[:releases]

      before_migrate do
        link "#{release_path}/#{site[:files]}" do
          to "#{node[:drupal][:server][:base]}/#{site_name}/files"
          link_type :symbolic
        end

       execute "drupal-copy-settings" do
        cmd = "cp #{settings_file} #{release_path}/#{site[:settings]}"
        Chef::Log.debug "drupal-copy-settings: #{ cmd}" if ::File.exists?(settings_file)
          command <<-EOF
            #{cmd}
            EOF
          only_if { ::File.exists?(settings_file) }
        end
      end

      before_restart do

        execute "drush-site-update" do
          cwd release_path
          command <<-EOF
            drush updb -y
            drush cc all
          EOF
          Chef::Log.debug "drush-site-update: cwd #{release_path}; drush updb -y; drush cc all" if ::File.exists?(settings_file)
          only_if { ::File.exists?(settings_file) }
        end

        if site[:database].nil?
          execute "drush-site-install" do
            drupal_user = data_bag_item('users', 'drupal')[node.chef_environment]
            install = site[:install]
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
            not_if { ::File.exists?(settings_file) }
            Chef::Log.debug "drush-site-install: cwd #{release_path}; #{cmd}" unless ::File.exists?(settings_file)
          end
        else
          # Install existing database.
        end

      end

      after_restart do
        # Make the current symlink relative in the _default environment to
        # facilitate working locally.
        if node.chef_environment == "_default"
          relative_path = release_path.gsub("#{node[:drupal][:server][:base]}/#{site_name}/","")
          execute "drupal-current-relative" do
            cwd "#{node[:drupal][:server][:base]}/#{site_name}/"
            command <<-EOF
              unlink current
              ln -s #{relative_path} current
            EOF
            only_if { ::File.exists?("#{node[:drupal][:server][:base]}/#{site_name}/current") }
          end
          # When working locally it is helpful to have the local code pointing
          # at the relevant branch.
          execute "drupal-switch-branch" do
            cwd "#{node[:drupal][:server][:base]}/#{site_name}/current"
            puts "beep git pull origin #{site[:repository][:revision]}"
            command <<-EOF
              git checkout #{site[:repository][:revision]}
              git pull origin #{site[:repository][:revision]}
            EOF
            only_if { ::File.exists?("#{node[:drupal][:server][:base]}/#{site_name}/current") }
          end
        end
      end

      symlink_before_migrate.clear
      create_dirs_before_symlink.clear
      purge_before_symlink.clear
      symlinks.clear
    end
  end
end
