# encoding: utf-8
require 'spec_helper'

describe 'drupal::php' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
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

  it 'includes the php recipe.' do
    expect(chef_run).to include_recipe('php')
  end

  it 'installs the php5-mysql package' do
    expect(chef_run).to install_package('php5-mysql')
  end

  it 'installs the php5-gd package' do
    expect(chef_run).to install_package('php5-gd')
  end

  it 'installs the php5-curl package' do
    expect(chef_run).to install_package('php5-curl')
  end
end
