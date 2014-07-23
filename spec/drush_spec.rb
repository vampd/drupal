# encoding: utf-8
require 'spec_helper'

describe 'nmddrupal::deploy_drush' do
  platforms = {
    'ubuntu' => {
      'versions' => ['12.04', '13.04', '14.04']
    },
    'centos' => {
      'versions' => ['5.9', '6.0', '6.2', '6.3', '6.4', '6.5', '7.0']
    }
  }
  platforms.each do |platform, versions|
    versions['versions'].each do |version|
      context "On #{platform} #{version}" do
        before do
          Fauxhai.mock(platform: platform, version: version)
        end

        let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

        it 'deploys drush' do
          expect(chef_run).to create_nmddrupal_drush('/opt/drush').with(
            revision: '6.3.0',
            repository: 'https://github.com/drush-ops/drush.git',
            executable: '/usr/bin/drush',
            owner: 'root',
            group: 'root',
            mode: 00755
          )
        end
      end
    end
  end
end
