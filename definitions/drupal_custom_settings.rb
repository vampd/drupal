#
# Cookbook Name:: drupal
# Definition:: drupal_custom_settings
#

define :drupal_custom_settings, :cookbook => "drupal", :source => "drupal_custom_settings.php.erb" do
  template params[:name] do
    source params[:source]
    cookbook params[:cookbook]
#    owner node[:drupal][:server][:web_user]
#    group node[:drupal][:server][:web_group]
    mode 0644
  end
end
