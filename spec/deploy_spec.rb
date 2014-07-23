# encoding: utf-8
require 'spec_helper'

describe 'nmddrupal::deploy_code' do
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

        it 'deploys drupal code' do
          expect(chef_run).to create_nmddrupal_code('/srv/www/example').with(
            revision: '7.x',
            repository: 'http://git.drupal.org/project/drupal.git',
            releases: 5,
            owner: 'www-data',
            group: 'www-data',
            mode: 00755
          )
        end
      end
    end
  end
end

describe 'nmddrupal::delete_code' do
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

        it 'deletes drupal code' do
          expect(chef_run).to delete_nmddrupal_code('/srv/www/example').with(
            action: [:delete]
          )
        end
      end
    end
  end
end
