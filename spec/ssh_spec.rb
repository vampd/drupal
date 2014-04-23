# encoding: utf-8
require 'spec_helper'

describe 'drupal::ssh' do

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

  it 'creates the /root/.ssh directory' do
    expect(chef_run).to create_directory('/root/.ssh').with(
      mode: 0700
    )
  end

  it 'creates /root/.ssh/config file' do
    expect(chef_run).to create_file('/root/.ssh/config').with(
      content: "Host *\nStrictHostKeyChecking no",
      mode: 0600
    )
  end
end
