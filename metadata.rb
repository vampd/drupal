name             'drupal'
maintainer       'Cyberswat Industries, LLC.'
maintainer_email 'kevin@cyberswat.com'
license          'Apache 2.0'
description      'Manages Drupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version          '2.0.0'

provides 'drupal::default'
recipe 'drupal::default', 'Does nothing.'

provides 'drupal::apache'
recipe 'drupal::apache', 'Creates virtualhost files for site.'

provides 'drupal::deploy'
recipe 'drupal::deploy', 'Deploys a Drupal site.'

provides 'drupal::drush'
recipe 'drupal::drush', 'Loads drush onto the server.'

provides 'drupal::init'
recipe 'drupal::init', 'Includes apt, apt-get-update, and loads unzip package.'

provides 'drupal::mysql'
recipe 'drupal::mysql', 'Drupal related database actions.'

provides 'drupal::php'
recipe 'drupal::php', 'Loads necessary php packages for Drupal.'

provides 'drupal::ssh'
recipe 'drupal::ssh', 'Manage ssh agents.'

depends 'apache2', '~> 1.8.14'
depends 'ssh_known_hosts', '~> 1.1.0'
depends 'apt', '~> 2.3.10'
