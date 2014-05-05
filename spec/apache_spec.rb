# encoding: utf-8
require 'spec_helper'

describe 'drupal::apache' do
  context 'Active site' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['drupal'] = {
          'sites' => {
            'example' => {
              'active' => 1
            }
          }
        }
      end.converge(described_recipe)
    end

    it 'enables apache2 service with attributes' do
      expect(chef_run).to enable_service('apache2').with(
        service_name: 'apache2',
        restart_command: '/usr/sbin/invoke-rc.d apache2 restart && sleep 1',
        reload_command: '/usr/sbin/invoke-rc.d apache2 reload && sleep 1',
        supports: {:restart=>true, :reload=>true, :status=>true},
        action: [:enable]
      )
    end
  end

  context 'Active site and remove action' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['drupal'] = {
          'sites' => {
            'example' => {
              'active' => 1,
              'deploy' => {
                'action' => ['remove']
              }
            }
          }
        }
      end.converge(described_recipe)
    end

    it 'deletes virtualhost file in sites-available and restarts apache2 service' do
      expect(chef_run).to delete_file('/etc/apache2/sites-available/example-80.conf').with(
      )
    end
    it 'deletes virtualhost file in sites-enabled and restarts apache2 service' do
      expect(chef_run).to delete_file('/etc/apache2/sites-enabled/example-80.conf').with(
      )
    end
  end
end
