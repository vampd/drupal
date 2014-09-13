# encoding: utf-8
require 'spec_helper'

describe 'drupal::apache' do
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

  it 'Includes the apache2 recipe.' do
    expect(chef_run).to include_recipe('apache2')
  end

  it 'Includes the apache2::mod_php5 recipe.' do
    expect(chef_run).to include_recipe('apache2::mod_php5')
  end

  it 'Includes the apache2::mod_rewrite recipe.' do
    expect(chef_run).to include_recipe('apache2::mod_rewrite')
  end
end
