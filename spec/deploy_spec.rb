# encoding: utf-8
require 'spec_helper'

describe 'nmddrupal::deploy' do
  context 'deploy flag set' do
    platforms = {
      'ubuntu' => ['12.04', '14.04'],
      'redhat' => ['5.9', '6.5']
    }
    platforms.each do |platform, versions|
      versions.each do |version|
        context "On #{platform} #{version}" do
          let(:chef_run) do
            ChefSpec::Runner.new(platform: platform, version: version) do |node|
              node.set['nmddrupal'] = {
                'sites' => {
                  'example' => {
                    'deploy' => {
                      'action' => ['deploy']
                    }
                  }
                }
              }
            end.converge(described_recipe)
          end
          it 'creates the server base directory' do
            expect(chef_run).to create_directory('/srv/www').with(
              owner: 'www-data',
              group: 'www-data',
              mode: 00755,
              recursive: true
            )
          end
          it 'deploys the drupal git repo' do
            expect(chef_run).to deploy_deploy('/srv/www/example').with(
              repository: 'https://github.com/drupal/drupal.git',
              revision: '7.28',
              keep_releases: 5,
              shallow_clone: false
            )
          end
        end
      end
    end
  end
end
