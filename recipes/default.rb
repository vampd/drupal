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
  not_if { ::File.exists?(node[:drupal][:server][:base]) }
end

directory node[:drupal][:server][:assets] do
  owner node[:drupal][:server][:web_user]
  group node[:drupal][:server][:web_group]
  mode 00755
  action :create
  recursive true
  not_if { ::File.exists?(node[:drupal][:server][:assets]) }
end

# Set up each drupal site.
Chef::Log.debug "drupal::default - node[:drupal] = #{node[:drupal].inspect}"

node[:drupal][:sites].each do |site_name, site|

  if site[:active]

    Chef::Log.debug "drupal::default site #{site_name.inspect} is active. site = #{site.inspect}"
    Chef::Log.debug "drupal::default site settings #{site[:drupal][:settings].inspect}"

    base = "#{node[:drupal][:server][:base]}/#{site_name}"
    assets = "#{node[:drupal][:server][:assets]}/#{site_name}"
    Chef::Log.debug "drupal::default base = #{base}"
    Chef::Log.debug "drupal::default assets = #{assets}"

    drupal_user = data_bag_item('sites', site_name)[node.chef_environment]
    Chef::Log.debug "drupal::default drupal_user #{drupal_user.inspect}"

#      mysql = "mysql -u #{drupal_user['db_user']} -p#{drupal_user['db_password']} #{site[:drupal][:settings][:db_name]} -h #{site[:drupal][:settings][:db_host]} -e "
#      Chef::Log.debug "drupal::default mysql #{mysql.inspect}"

    ssh_known_hosts_entry site[:repository][:host]

    template "/root/#{site_name}-files.sh" do
      source 'files.sh.erb'
      mode 0755
      owner 'root'
      group 'root'
      variables(
        :owner => node[:drupal][:server][:web_user],
        :group => node[:drupal][:server][:web_group],
        :assets => assets,
        :files => "#{base}/current/#{site[:drupal][:settings][:files]}"
      )
    end

    directory assets do
#        owner node[:drupal][:server][:web_user]
#        group node[:drupal][:server][:web_group]
      mode 00755
      action :create
      not_if { ::File.exists?(assets) }
    end

    link "#{node[:drupal][:server][:base]}/#{site_name}" do
      to assets
    end

    directory "#{assets}/files" do
      not_if { ::File.exists?("#{assets}/files") }
#        owner node[:drupal][:server][:web_user]
#        group node[:drupal][:server][:web_group]
      mode 00755
      action :create
      recursive true
    end

    directory "#{assets}/shared" do
#        owner node[:drupal][:server][:web_user]
#        group node[:drupal][:server][:web_group]
      mode 00755
      action :create
      recursive true
      not_if { ::File.exists?("#{assets}/shared") }
    end

    # deploy only if deploy action present
    deploy base do
      only_if { site[:deploy][:action].any? { |action| action == 'deploy' } }
      repository site[:repository][:uri]
      revision site[:repository][:revision]
      keep_releases site[:deploy][:releases]

      before_migrate do
        if site[:repository][:submodule]
          bash 'Git submodule init and submodule update' do
          cwd release_path
          cmd = 'git submodule init && git submodule update';
          code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end
        end

        # If the Drush make hash is nil, then do nothing, else make the site
        if site.has_key?("drush_make") && !site[:drush_make][:files].nil?

          # we are going to remove all the files in this folder, this will allow
          # the drush make to occur
          bash 'Remove all cloned files except the .git folder' do
            user 'root'
            cwd release_path
            cmd = 'rm -rf ./*'
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end

          template "#{release_path}/build.make" do
            source 'build.make.erb'
            mode 0755
            owner 'root'
            group 'root'
            variables(
              :api => site[:drush_make][:api],
              :url => site[:repository][:uri],
              :branch => site[:repository][:revision],
              :profile => site[:drupal][:settings][:profile],
              :includes => site[:drush_make][:files]
            )
            only_if { site[:drush_make][:template] == true }
          end

          # Make Files
          make_files = ''
          site[:drush_make][:files].each do |file, value|
            make_files << "#{value} "
          end

          bash "Get drush make files back: #{make_files}" do
            user 'root'
            cwd release_path
            cmd = "git checkout #{make_files}"
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end

          bash "Run drush make for #{site_name}" do
            user 'root'
            cwd release_path
            if site[:drush_make][:template] == true
              cmd = 'drush make build.make -y'
            else
              cmd = "drush make #{site[:drush_make][:files][:default]} -y"
            end

            unless site[:drush_make][:arguments].nil?
              site[:drush_make][:arguments].each do |flag|
                cmd << " #{flag}"
              end
            end

            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end

          bash "Remove make files from #{site_name} directory" do
            user 'root'
            cwd release_path
            cmd = "rm -rf #{make_files}"
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
          end

        end

        Chef::Log.debug("Drupal::default: before_migrate: release_path = #{release_path}")
        Chef::Log.debug("Drupal::default: before_migrate: link #{release_path}/#{site[:drupal][:settings][:files]} to #{assets}/files")
        link "#{release_path}/#{site[:drupal][:settings][:files]}" do
          to "#{assets}/files"
          link_type :symbolic
        end

        Chef::Log.debug("Drupal::default: before_migrate: template #{release_path}/#{site[:drupal][:settings][:settings][:default][:location]}")
        template "#{release_path}/#{site[:drupal][:settings][:settings][:default][:location]}" do
          path "#{release_path}/#{site[:drupal][:settings][:settings][:default][:location]}"
          version = site[:drupal][:version].split('.')[0]
          source "d#{version}.settings.php.erb"
         # owner node[:server][:web_user]
         # group node[:server][:web_group]
          mode 0644
          variables(
           :database => site[:drupal][:settings][:db_name],
           :username => drupal_user['db_user'],
           :password => drupal_user['db_password'],
           :host => site[:drupal][:settings][:db_host],
           :driver => site[:drupal][:settings][:db_driver],
           :prefix => site[:drupal][:settings][:db_prefix],
           :settings_custom => site[:drupal][:settings][:settings]
          )
        end
        Chef::Log.debug("Drupal::default: before_migrate: drupal_custom_settings #{release_path}/#{site[:drupal][:settings]}")
        site[:drupal][:settings][:settings].each do |setting_name, setting|
          unless setting[:template].nil?
            Chef::Log.debug("Drupal::default: before_migrate: drupal_custom_settings #{release_path}/#{setting[:location]}")
            drupal_custom_settings "#{release_path}/#{setting[:location]}" do
              cookbook site[:drupal][:settings][:cookbook]
              source setting[:template]
            end
          end
        end
      end

      after_restart do
        # Modifications to facilitate a local working environment.
        if Chef::Config[:solo]


          bash 'disable selinux' do
            cmd = 'type setenforce &>/dev/null && setenforce permissive'
            Chef::Log.debug("Drupal::default: after_restart: selinux: #{cmd}")
            code <<-EOH
              set -x
              set -e
              #{cmd}
            EOH
            only_if { node[:platform_family] == 'redhat' || node[:platform_family] == 'centos'}
          end

          execute 'drupal-current-relative' do
            cwd base
            cmd = "unlink current; ln -s #{release_path.gsub("#{base}/", "")} current"
            Chef::Log.debug("Drupal::default: after_restart: relative symlink: base = #{base.inspect}; cmd = #{cmd.inspect}")
            command <<-EOF
              set -x
              set -e
              #{cmd}
            EOF
            only_if { ::File.exists?("#{base}/current") }
          end

          execute 'drupal-switch-branch' do
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

        Chef::Log.debug("Drupal::default: after_restart: execute: /root/#{site_name}-files.sh")
        bash 'change file ownership' do
          code <<-EOH
            /root/#{site_name}-files.sh
          EOH
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
        # Because of how drush make works, we have to override the git operations
        # this means that we have to change locations of the .git directory, etc
        # We move .git because of how the build happens
        bash "Move  #{site_name} .git to profile" do
          only_if { site.has_key?("drush_make") && !site[:drush_make][:files].nil? }
          user 'root'
          cwd "#{node[:drupal][:server][:base]}/#{site_name}/current"
          cmd = "mv .git profiles/#{site[:drupal][:settings][:profile]}"
          code <<-EOH
            set -x
            set -e
            #{cmd}
          EOH
        end
      end

      symlink_before_migrate.clear
      create_dirs_before_symlink.clear
      purge_before_symlink.clear
      symlinks.clear
    end

    bash "drush-site-install-#{site_name}" do
      cwd "#{base}/current/#{site[:drupal][:settings][:docroot]}"
      user 'root'
      cmd = "drush -y site-install #{site[:drupal][:settings][:profile]}"

      unless site[:drupal][:install].nil?
        site[:drupal][:install].each do |flag, value|
          cmd << " #{flag}=#{value}"
        end
      end

      cmd << " --account-name=#{drupal_user['admin_user']} --account-pass=#{drupal_user['admin_pass']}"
      only_if { site[:deploy][:action].any? { |action| action == 'install' } }

      Chef::Log.debug("Drupal::default: before_restart: execute: #{cmd.inspect}") if site[:deploy][:action].any? { |action| action == 'install' }
      code <<-EOH
        set -x
        set -e
        #{cmd}
      EOH
    end

    bash "drush-download-registry-rebuild-#{site_name}" do
      cwd "#{base}"
      cmd = "drush dl registry_rebuild; "
      code <<-EOH
        set -x
        #{cmd}
      EOH
      only_if { site[:drupal][:registry_rebuild] }
    end

    bash "drush-site-registry-rebuild-#{site_name}" do
      cwd "#{base}/current/#{site[:drupal][:settings][:docroot]}"
      cmd = "drush rr; drush cc all; drush rr"
      code <<-EOH
        set -x
        #{cmd}
      EOH
      only_if { site[:drupal][:registry_rebuild] }
    end

    bash "drush-update-admin-password-on-import" do
      cwd "#{base}/current/#{site[:drupal][:settings][:docroot]}"
      user 'root'
      cmd = "drush upwd #{drupal_user['admin_user']} --password=#{drupal_user['admin_pass']}"
      only_if { site[:deploy][:action].any? { |action| action == 'import' } }

      Chef::Log.debug("Drupal::default: before_restart: execute: #{cmd.inspect}") if site[:deploy][:action].any? { |action| action == 'import' }
      code <<-EOH
        set -x
        set -e
        #{cmd}
      EOH
    end

    bash "drush-site-update-#{site_name}" do
      cwd "#{base}/current/#{site[:drupal][:settings][:docroot]}"
      user 'root'
      cmd = 'drush updb -y; drush cc all'
      only_if { site[:deploy][:action].any? { |action| action == 'update' } }
      Chef::Log.debug("Drupal::default: action = 'update' execute = #{cmd.inspect}") if site[:deploy][:action].any? { |action| action == 'update' }
      code <<-EOH
        set -x
        set -e
        #{cmd}
      EOH
    end
  end
end
