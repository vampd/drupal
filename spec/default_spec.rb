# encoding: utf-8
require 'spec_helper'

describe 'drupal::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['drupal'] = {
        'sites' => {
          'example' => {
            'active' => 1,
            'deploy' => {
              'action' => ['deploy']
            }
          }
        }
      }
    end.converge(described_recipe)
  end
  before do
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

  it 'creates the server base directory' do
    expect(chef_run).to create_directory('/srv/www').with(
      owner: 'www-data',
      group: 'www-data',
      mode: 00755,
      recursive: true
    )
  end

  it 'creates the /assets directory' do
    expect(chef_run).to create_directory('/assets').with(
      owner: 'www-data',
      group: 'www-data',
      mode: 00755,
      recursive: true
    )
  end

  it 'creates a /root/example-files.sh file with attributes' do
    expect(chef_run).to create_template('/root/example-files.sh').with(
      owner:   'root',
      group:  'root',
      mode: 0755,
      source: 'files.sh.erb'
    )
  end

  it 'creates the /assets/example directory' do
    expect(chef_run).to create_directory('/assets/example').with(
      mode: 00755
    )
  end

  it 'creates a link from /srv/www/example to /assets/example' do
    expect(chef_run).to create_link('/srv/www/example').with(
      to: '/assets/example'
    )
  end

  it 'creates the /assets/example/files directory' do
    expect(chef_run).to create_directory('/assets/example/files').with(
      mode: 00755,
      recursive: true
    )
  end

  it 'creates the /assets/example/shared directory' do
    expect(chef_run).to create_directory('/assets/example/shared').with(
      mode: 00755,
      recursive: true
    )
  end

  it 'deploys the drupal git repo' do
    expect(chef_run).to deploy_deploy('/srv/www/example').with(
      repository: 'https://github.com/drupal/drupal.git',
      revision: '7.26',
      keep_releases: 5,
      shallow_clone: false
    )
  end
end
