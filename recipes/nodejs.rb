if node[:drupal][:nodejs]
  include_recipe "nodejs"
  include_recipe "nodejs::install_from_package"
  include_recipe "nodejs::npm"
  if node[:drupal][:nodejs][:packages]
    cmd = ""
    node[:drupal][:nodejs][:packages].each do |package|
      cmd << "npm install -g #{package};"
    end
    bash "Install NPM Packages" do
      code <<-EOH
        #{cmd}
      EOH
    end
  end
end
