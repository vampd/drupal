# encoding: utf-8
require 'spec_helper'

describe 'nmddrupal::drush' do
  context 'deploy drush' do
    platforms = {
      'ubuntu' => ['12.04', '14.04'],
      'redhat' => ['5.9', '6.5']
    }
    platforms.each do |platform, versions|
      versions.each do |version|
        context "On #{platform} #{version}" do
          let(:chef_run) do
            ChefSpec::Runner.new(platform: platform, version: version) do |node|
              puts node.platform
              node.set['nmddrupal'] = {
                'sites' => {
                  'example' => {
                  }
                }
              }
            end.converge(described_recipe)
          end
          it 'creates the /opt/drush directory' do
            expect(chef_run).to create_directory('/opt/drush').with(
              owner: 'root',
              group: 'root',
              mode: '0755'
            )
          end
          it 'creates the /opt/drush/shared directory' do
            expect(chef_run).to create_directory('/opt/drush/shared').with(
              owner: 'root',
              group: 'root',
              mode: '0755'
            )
          end
          it 'deploys /opt/drush' do
            expect(chef_run).to deploy_deploy('/opt/drush').with(
              repository: 'https://github.com/drush-ops/drush.git',
              revision: '6.3.0'
            )
          end
        end
      end
    end
  end
end
