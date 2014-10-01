# encoding: utf-8
require 'spec_helper'

describe 'drupal::init' do
  context 'on ubuntu' do
    before do
      Fauxhai.mock(platform: 'ubuntu', version: '12.04')
    end

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

    it 'Includes the apt recipe.' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'runs apt-get-update execute' do
      expect(chef_run).to run_execute('apt-get-update').with(
        command: 'apt-get update'
      )
    end

    it 'installs the unzip package' do
      expect(chef_run).to install_package('unzip')
    end
  end
end
