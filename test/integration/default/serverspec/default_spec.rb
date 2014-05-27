# encoding: utf-8
require 'serverspec'

# include Serverspec::Helper::Exec
# include Serverspec::Helper::DetectOS

# RSpec.configure do |c|
#   c.before :all do
#     c.path = '/usr/bin'
#   end
# end


describe file('/default/files') do
  it { should be_directory }
  it { should be mode 755 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end
