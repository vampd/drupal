# encoding: utf-8
default[:nmddrupal][:server][:base] = '/srv/www'

# set default web and files users
default[:nmddrupal][:server][:users][:web] = 'www-data:www-data'
default[:nmddrupal][:server][:users][:files] =
  node[:nmddrupal][:server][:users][:web]

# drupal specific settings
node[:nmddrupal][:sites].each do |name, _site|
  default[:nmddrupal][:sites][name][:active] = 0
  default[:nmddrupal][:sites][name][:deploy][:action] = []
  default[:nmddrupal][:sites][name][:deploy][:releases] = 5

  # default to bringing in latest drupal
  default[:nmddrupal][:sites][name][:repository][:host] = 'github.com'
  default[:nmddrupal][:sites][name][:repository][:uri] =
    'https://github.com/drupal/drupal.git'
  default[:nmddrupal][:sites][name][:repository][:revision] = '7.28'
  default[:nmddrupal][:sites][name][:repository][:shallow_clone] = false
end
