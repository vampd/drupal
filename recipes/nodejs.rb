if node[:nodejs]
  include_recipe "nodejs"
  include_recipe "nodejs::install_from_package"
  include_recipe "nodejs::npm"
  if node[:nodejs][:packages]
    cmd = ""
    node[:nodejs][:packages].each do |package|
      cmd << "npm install -g #{package};"
    end
    bash "Install NPM Packages" do
      code <<-EOH
        #{cmd}
      EOH
    end
  end
end
