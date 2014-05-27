name 'nmd-drupal'
maintainer 'New Media Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'
description 'Installs/Configures nmd-drupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.0'
supports 'ubuntu'
supports 'centos'

desc = ' Manages the installation and configuration of Drupal.'
description desc

long_description
recipe 'nmd-drupal::default', desc
