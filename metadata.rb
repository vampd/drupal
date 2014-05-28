name 'nmd-drupal'
maintainer 'New Media Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'
description 'Installs/Configures nmd-drupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.0'
supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 6.0'

desc = 'Manages Drupal.'
description desc

long_description 'Manages the installation and configuration of Drupal.'
recipe 'nmd-drupal::default', desc
recipe 'nmd-drupal::files', 'Manages files'
recipe 'nmd-drupal::30ish', 'Goes beep'

grouping 'nmd-drupal/files',
         title: 'Files attributes',
         description: 'Files recipe attributes'

attribute 'drupal/files/path',
          display_name: '[:drupal][:files][:path]',
          description: 'This is the root level files directory path.',
          type: 'string',
          required: 'recommended',
          recipes: ['nmd-drupal::files'],
          default: '/default/files'

attribute 'drupal/files/owner',
          display_name: '[:drupal][:files][:owner]',
          description: 'This is the root level files directory owner.',
          type: 'string',
          required: 'recommended',
          recipes: ['nmd-drupal::files'],
          default: 'root'

attribute 'drupal/files/group',
          display_name: '[:drupal][:files][:path]',
          description: 'This is the root level files directory path group owner
          .',
          type: 'string',
          required: 'recommended',
          recipes: ['nmd-drupal::files'],
          default: 'root'

attribute 'drupal/files/mode',
          display_name: '[:drupal][:files][:mode]',
          description: 'This is the root level files directory mode.',
          type: 'string',
          required: 'recommended',
          recipes: ['nmd-drupal::files'],
          default: '755'
