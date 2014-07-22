# encoding: utf-8
require 'spec_helper'

describe 'nmddrupal::files' do
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

        it 'Creates files directory' do
          expect(chef_run).to create_directory('/default/files').with(
            user: 'root',
            group: 'root',
            mode: '0755'
          )
        end
      end
    end
  end
end
