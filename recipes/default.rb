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

directory node[:drupal][:server][:assets] do
  owner node[:drupal][:server][:web_user]
  group node[:drupal][:server][:web_group]
  mode 00755
  action :create
  recursive true
end

# Set up each drupal site.
Chef::Log.debug "drupal::default - node[:drupal] = #{node[:drupal].inspect}"

node[:drupal][:sites].each do |site_name, site|

  if site[:active]
    Chef::Log.debug "drupal::default site #{site_name.inspect} is active. site = #{site.inspect}"
    Chef::Log.debug "drupal::default site settings #{site[:drupal][:settings].inspect}"

      base = "#{node[:drupal][:server][:base]}/#{site_name}"
      assets = "#{node[:drupal][:server][:assets]}/#{site_name}"
      drupal_user = data_bag_item('sites', site_name)[node.chef_environment]
      Chef::Log.debug "drupal::default drupal_user #{drupal_user.inspect}"

#      mysql = "mysql -u #{drupal_user['db_user']} -p#{drupal_user['db_password']} #{site[:drupal][:settings][:db_name]} -h #{site[:drupal][:settings][:db_host]} -e "
#      Chef::Log.debug "drupal::default mysql #{mysql.inspect}"

      ssh_known_hosts_entry site[:repository][:host]

      template "/root/#{site_name}-files.sh" do
        source "files.sh.erb"
        mode 0755
        owner "root"
        group "root"
        variables({
          :owner => node[:drupal][:server][:web_user],
          :group => node[:drupal][:server][:web_group],
          :assets => "#{assets}",
          :files => "#{base}/current/sites/default/files",
        })
      end

      directory assets do
        owner node[:drupal][:server][:web_user]
        group node[:drupal][:server][:web_group]
        mode 00755
        action :create
      end

      link "#{node[:drupal][:server][:base]}/#{site_name}" do
        to assets
      end

      directory "#{assets}/files" do
        owner node[:drupal][:server][:web_user]
        group node[:drupal][:server][:web_group]
        mode 00755
        action :create
        recursive true
      end
      directory "#{assets}/shared" do
        owner node[:drupal][:server][:web_user]
        group node[:drupal][:server][:web_group]
        mode 00755
        action :create
        recursive true
      end

      if site[:deploy][:action] == 'clean'
        execute "drupal-clean-releases" do
          cmd = "rm -rf #{base}/releases"
          Chef::Log.debug("Drupal::default: clean install: #{cmd}") if ::File.exists?("#{base}/releases")
          command <<-EOF
            #{cmd}
            EOF
          only_if { ::File.exists?("#{base}/releases") }
        end
      end

      deploy base do
        repository site[:repository][:uri]
        revision site[:repository][:revision]
        keep_releases site[:deploy][:releases]

        before_migrate do
          Chef::Log.debug("Drupal::default: before_migrate: release_path = #{release_path}")
          Chef::Log.debug("Drupal::default: before_migrate: link #{release_path}/#{site[:drupal][:settings][:files]} to #{assets}/files")
          link "#{release_path}/#{site[:drupal][:settings][:files]}" do
            to "#{assets}/files"
            link_type :symbolic
          end

          Chef::Log.debug("Drupal::default: before_migrate: template #{release_path}/#{site[:drupal][:settings][:settings]}")
          template "drupal-settings" do
            path "#{release_path}/#{site[:drupal][:settings][:settings]}"
            version = "#{site[:drupal][:version]}".split('.')[0]
            source "d#{version}.settings.php.erb"
            owner node[:server][:web_user]
            group node[:server][:web_group]
            mode 0644
            variables({
             :database => site[:drupal][:settings][:db_name],
             :username => drupal_user['db_user'],
             :password => drupal_user['db_password'],
             :host => site[:drupal][:settings][:db_host],
             :driver => site[:drupal][:settings][:db_driver],
             :prefix => site[:drupal][:settings][:db_prefix],
             :settings_custom => site[:drupal][:settings][:custom]
            })
          end

          Chef::Log.debug("Drupal::default: before_migrate: drupal_custom_settings #{release_path}/#{site[:drupal][:settings][:custom]}")
          drupal_custom_settings "#{release_path}/#{site[:drupal][:settings][:custom]}" do
            cookbook site[:drupal][:settings][:cookbook]
            source site[:drupal][:settings][:template]
          end

        end

        before_restart do
          #Use a CSS Preprocessor
          unless site[:css_preprocessor].nil?
            # If using bundler, a different process is needed
            if site[:css_preprocessor][:engine] == 'compass'
              if site[:css_preprocessor][:compile]

                Chef::Log.debug("Drupal::default: before_restart: site[:css_preprocessor] #{site[:css_preprocessor].inspect}")
                if site[:css_preprocessor][:use_bundler]
                  gem_package "bundler" do
                    not_if "gem list | grep bundler"
                    action :install
                  end
                  cmd = "bundle install; bundle exec compass compile;"
                else
                  site[:css_processor][:gems].each do |g|
                    gem_package "#{g}" do
                      not_if "gem list | grep #{g}"
                      action :install
                    end
                  end
                  if Chef::Config[:solo]
                    cmd = "set -x; set -e; compass clean; compass compile;"
                  else
                    cmd = "set -x; set -e; compass clean; compass watch;"
                  end
                end
                Chef::Log.debug("Drupal::default: before_restart: site[:css_preprocessor][:engine] = #{site[:css_preprocessor][:engine].inspect}") unless site[:css_preprocessor][:engine].nil?
                bash "compile CSS" do
                  user "root"
                  cwd "#{release_path}/#{site[:css_preprocessor][:location]}"
                  code <<-EOH
                    #{cmd}
                  EOH
                end
              end
            end
          end

          Chef::Log.debug("Drupal::default: before_restart: execute: /root/#{site_name}-files.sh")
          bash "change file ownership" do
            code <<-EOH
              /root/#{site_name}-files.sh
            EOH
          end

          bash "drush-site-update" do
            cwd release_path
            user "root"
            cmd = "drush updb -y; drush cc all"
            only_if { site[:deploy][:action] == 'update' }
            Chef::Log.debug("Drupal::default: action = 'update' execute = #{cmd.inspect}") if site[:deploy][:action] == 'update'
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end

          bash "drush-site-install" do
            cwd release_path
            user "root"
            cmd = "drush -y site-install #{site[:drupal][:settings][:profile]}"
            site[:drupal][:install].each do |flag, value|
              cmd << " #{flag}=#{value}"
            end
            cmd << " --account-name=#{drupal_user['admin_user']} --account-pass=#{drupal_user['admin_pass']}"
            cwd release_path
            only_if { site[:deploy][:action] == 'clean' }

            Chef::Log.debug("Drupal::default: before_restart: execute: #{cmd.inspect}") if site[:deploy][:action] == 'clean'
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end
        end

        after_restart do
          # Modifications to facilitate a local working environment.
          if Chef::Config[:solo]

            case node['platform_family']
            when "redhat", "centos"
              bash "disable selinux" do
                cmd = "type setenforce &>/dev/null && setenforce permissive"
                Chef::Log.debug("Drupal::default: after_restart: selinux: #{cmd}")
                code <<-EOH
                  set -x
                  set -e
                  #{cmd}
                EOH
              end
            end

            execute "drupal-current-relative" do
              cwd base
              cmd = "unlink current; ln -s #{release_path.gsub("#{base}/","")} current"
              Chef::Log.debug("Drupal::default: after_restart: relative symlink: base = #{base.inspect}; cmd = #{cmd.inspect}")
              command <<-EOF
                set -x
                set -e
                #{cmd}
              EOF
              only_if { ::File.exists?("#{base}/current") }
            end

            execute "drupal-switch-branch" do
              cwd "#{base}/current"
              cmd = "git checkout #{site[:repository][:revision]} && git pull origin #{site[:repository][:revision]}"
              Chef::Log.debug("Drupal::default: after_restart: _default environment: cd #{base}; #{cmd}")
              command <<-EOF
                set -x
                set -e
                #{cmd}
              EOF
              only_if { ::File.exists?("#{base}/current") }
            end
          end
          # Optionally define additonal git remotes. These are in addition to
          # the the default 'origin' remote provided by git clone.
          unless site[:repository][:remotes].nil?
            site[:repository][:remotes].each do |remote, uri|
              execute "drupal-add-remote-#{remote}" do
                cwd "#{node[:drupal][:server][:base]}/#{site_name}/current"
                command "git remote add #{remote} #{uri}"
                only_if { ::File.exists?("#{node[:drupal][:server][:base]}/#{site_name}/current") }
              end
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

