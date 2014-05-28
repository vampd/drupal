# encoding: utf-8
require 'spec_helper'

describe 'nmd-drupal::files' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  it 'Creates files directory' do
    expect(chef_run).to create_directory('/default/files').with(
      user: 'root',
      group: 'root',
      mode: '0755'
    )
  end
end
