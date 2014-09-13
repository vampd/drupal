name             'drupal'
maintainer       'Cyberswat Industries, LLC.'
maintainer_email 'kevin@cyberswat.com'
license          'Apache 2.0'
description      'Manages Drupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version          '2.0.0'
recipe            'drupal::apache', 'Loads and configures apache'

depends 'apache2'
depends 'mysql'
depends 'database'
depends 'php'
depends 'ssh_known_hosts'
depends 'apt'
