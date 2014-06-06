# encoding: utf-8
require 'spec_helper'

describe 'drupal::drush' do
  context 'Drush 6.x' do
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

    it 'creates the /opt/drush directory' do
      expect(chef_run).to create_directory('/opt/drush').with(
        owner: 'root',
        group: 'root',
        mode: '0755',
        recursive: true
      )
    end

    it 'creates the /opt/drush/shared directory' do
      expect(chef_run).to create_directory('/opt/drush/shared').with(
        owner: 'root',
        group: 'root',
        mode: '0755'
      )
    end

    it 'deploys the drush' do
      expect(chef_run).to deploy_deploy('/opt/drush').with(
        repository: 'https://github.com/drush-ops/drush.git',
        revision: '6.2.0',
        keep_releases: 1
      )
    end

    it 'creates a link from /usr/bin/drush to /opt/drush/current/drush' do
      expect(chef_run).to create_link('/usr/bin/drush').with(
        to: '/opt/drush/current/drush',
        link_type: :symbolic
      )
    end
  end


  context 'Drush 7.x' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['drupal'] = {
          'drush' => {
            'revision' => '7.0.0-alpha3'
          },
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

    it 'installs drush using composer' do
      expect(chef_run).to run_execute('install-drush-using-composer').with(
        command: 'composer global require drush/drush:dev-master'
      )
    end
  end
end
