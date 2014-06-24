# encoding: utf-8
require 'spec_helper'

describe 'nmddrupal::files', :ubuntu && :rhel do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['nmddrupal'] = {
        'sites' => {
          'example' => {
          }
        }
      }
    end.converge(described_recipe)
  end

  it 'Creates files directory' do
    expect(chef_run).to create_directory('/default/files').with(
      user: 'root',
      group: 'root',
      mode: '0755'
    )
  end
end
