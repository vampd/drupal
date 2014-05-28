# encoding: utf-8
require 'serverspec'

describe file('/default/files') do
  it { should be_directory }
  it { should be mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end
