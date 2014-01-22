node_server node[:node][:server_name] do
  script node[:node][:script_location]
  user node[:node][:user]
  dependency node[:node][:dependencies]
  args node[:node][:args]
  init_style :runit
  action node[:node][:action]
end
node_npm "yo" do
    action :install
end
