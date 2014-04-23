# encoding: utf-8
require 'spec_helper'

describe 'drupal::mysql' do
  before do
    Fauxhai.mock(platform: 'ubuntu', version: '12.04')
  end

  before do
    stub_data_bag_item('users', 'mysql').and_return(
      id: 'mysql',
      _default: {
        root: 'root',
        replication: 'replication',
        debian: 'debian'
      }
    )
    stub_data_bag_item('sites', 'example').and_return(
      id: 'example',
      _default: {
        db_user: 'drupal',
        db_password: 'drupal',
        admin_user: 'example_admin',
        admin_pass: 'admin'
      }
    )
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['db'] = {
        'driver' => 'mysql',
        'client_recipe' => 'mysql::client',
        'grant_hosts' => ['localhost']
      }
      node.set['drupal'] = {
        'sites' => {
          'example' => {
            'active' => 1,
            'deploy' => {
              'action' => ['deploy', 'install', 'import']
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

  it 'Includes the database recipe.' do
    expect(chef_run).to include_recipe('database')
  end

  it 'Includes the database::mysql recipe.' do
    expect(chef_run).to include_recipe('database::mysql')
  end

  it 'Runs a bash script to import an existing database.' do
    expect(chef_run).to run_bash('Import existing example database.').with(
      user: 'root',
      code: "          set -x\n          set -e\n          mysql -u  -proot example -h localhost -e  'SOURCE example.sql'\n"
    )
  end
end
