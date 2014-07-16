# encoding: utf-8
default[:nmddrupal][:path] = '/srv/www/example'
default[:nmddrupal][:owner] = 'www-data'
default[:nmddrupal][:group] = 'www-data'
default[:nmddrupal][:mode] = 00755
default[:nmddrupal][:repository] = 'http://git.drupal.org/project/drupal.git'
default[:nmddrupal][:revision] = '7.x'
default[:nmddrupal][:releases] = 5
