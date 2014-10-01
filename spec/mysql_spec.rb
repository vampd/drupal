# encoding: utf-8
require 'spec_helper'

describe 'drupal::mysql' do
  context 'Active site action deploy install import' do
    before do
      Fauxhai.mock(platform: 'ubuntu', version: '12.04')
    end

    before do
      stub_data_bag_item('sites', 'example').and_return(
        id: 'example',
        _default: {
          admin_user: 'example_admin',
          admin_pass: 'admin',
          mysql: {
            site_user: 'drupal',
            site_password: 'drupal',
            maintenance_user: 'root',
            maintenance_password: 'root'
          }
        }
      )
    end

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['drupal'] = {
          'sites' => {
            'example' => {
              'active' => 1,
              'deploy' => {
                'action' => %w(deploy install import)
              },
              'drupal' => {
                'settings' => {
                  'db_file' => 'example.sql'
                }
              }
            }
          }
        }
      end.converge(described_recipe)
    end

    it 'Runs a bash script to drop an existing database.' do
      expect(chef_run).to run_bash('Drop database example.').with(
        user: 'root',
        code: "          set -x\n          set -e\n          mysql -u root -proot -h localhost -e 'DROP DATABASE IF EXISTS example'\n"
      )
    end

    it 'Runs a bash script to create a database.' do
      expect(chef_run).to run_bash('Create example database.').with(
        user: 'root',
        code: "          set -x\n          set -e\n          mysql -u root -proot -h localhost -e 'CREATE DATABASE example'\n"
      )
    end

    it 'Runs a bash script to import a database.' do
      expect(chef_run).to run_bash('Import existing example database.').with(
        user: 'root',
        code: "          set -x\n          set -e\n          mysql -u root -proot example -h localhost -e  'SOURCE example.sql'\n"
      )
    end
  end
  context 'Active site action remove' do
    before do
      stub_data_bag_item('sites', 'example').and_return(
        id: 'example',
        _default: {
          admin_user: 'example_admin',
          admin_pass: 'admin',
          mysql: {
            site_user: 'drupal',
            site_password: 'drupal',
            maintenance_user: 'root',
            maintenance_password: 'root'
          }
        }
      )
    end

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['drupal'] = {
          'sites' => {
            'example' => {
              'active' => 1,
              'deploy' => {
                'action' => %w(remove)
              },
              'drupal' => {
                'settings' => {
                  'db_file' => 'example.sql'
                }
              }
            }
          }
        }
      end.converge(described_recipe)
    end

    it 'Runs a bash script to drop an existing database.' do
      expect(chef_run).to run_bash('Drop example database.').with(
        user: 'root',
        code: "        set -x\n        set -e\n        mysql -u root -proot -h localhost -e 'DROP DATABASE IF EXISTS example'\n"
      )
    end
  end
end
