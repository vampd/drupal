# encoding: utf-8
name 'nmddrupal'
maintainer 'New Media Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'
description 'Installs/Configures nmddrupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.3'
supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 6.0'

desc = 'Manages Drupal.'
description desc

depends 'git'
depends 'ssh_known_hosts', '~> 1.3.0'
depends 'mysql', '~> 5.3.6'
depends 'database', '~> 2.2.0'

long_description 'Manages the installation and configuration of Drupal.'
recipe 'nmddrupal::default', desc
delete_code_desc = 'An example recipe that illustrates using the '
delete_code_desc << 'nmddrupal_code LWRP to delete Drupal code.'
recipe 'nmddrupal::delete_code', delete_code_desc

deploy_code_desc = 'An example recipe that illustrates using the '
deploy_code_desc << 'nmddrupal_code LWRP to deploy Drupal code.'
recipe 'nmddrupal::deploy_code', deploy_code_desc

deploy_mysql = 'Example wrapper recipe that creates a mysql database, mysql '
deploy_mysql << 'database user, and sets grants for Drupal.'
recipe 'nmddrupal::deploy_mysql', deploy_mysql

delete_mysql = 'Example wrapper recipe that removes a mysql database, user '
delete_mysql << 'and grants.'
recipe 'nmddrupal::delete_mysql', delete_mysql

recipe 'nmddrupal::files', 'Manages files'

grouping(
  'nmddrupal',
  title: 'nmddrupal attributes',
  description: 'nmddrupal defaultattributes'
)

attribute(
  'nmddrupal/path',
  display_name: '[:nmddrupal][:path]',
  description: 'The path of the code being requested.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: '/srv/www/example'
)

attribute(
  'nmddrupal/owner',
  display_name: '[:nmddrupal][:owner]',
  description: 'The owner of the directory the code is being deployed to.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: 'www-data'
)

attribute(
  'nmddrupal/group',
  display_name: '[:nmddrupal][:group]',
  description: 'The group of the directory the code is being deployed to.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: 'www-data'
)

attribute(
  'nmddrupal/mode',
  display_name: '[:nmddrupal][:mode]',
  description: 'The mode of the directory the code is being deployed to.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: 00755
)

attribute(
  'nmddrupal/repository',
  display_name: '[:nmddrupal][:repository]',
  description: 'The repository to request the code from.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: 'http://git.drupal.org/project/drupal.git'
)

attribute(
  'nmddrupal/revision',
  display_name: '[:nmddrupal][:revision]',
  description: 'The repository revision to request the code from.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: '7.x'
)

attribute(
  'nmddrupal/releases',
  display_name: '[:nmddrupal][:releases]',
  description: 'The number of releases to keep.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy_code'],
  default: '7.x'
)

grouping(
  'nmddrupal/drush',
  title: 'Drush attributes',
  description: 'Drush recipe attributes'
)

attribute(
  'nmddrupal/drush/revision',
  display_name: '[:nmddrupal][:drush][:revision]',
  description: 'This is the version of drush to install.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: '6.3.0'
)

attribute(
  'nmddrupal/drush/repository',
  display_name: '[:nmddrupal][:drush][:repository]',
  description: 'This is the code repository to reference.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: 'https://github.com/drush-ops/drush.git'
)

attribute(
  'nmddrupal/drush/path',
  display_name: '[:nmddrupal][:drush][:path]',
  description: 'The path to deploy to.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: '/opt/drush'
)

attribute(
  'nmddrupal/drush/executable',
  display_name: '[:nmddrupal][:drush][:executable]',
  description: 'This is the symlinked file to the drush binary.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: '/usr/bin/drush'
)

attribute(
  'nmddrupal/drush/owner',
  display_name: '[:nmddrupal][:drush][:owner]',
  description: 'This is owner of the executable binary.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: 'root'
)

attribute(
  'nmddrupal/drush/group',
  display_name: '[:nmddrupal][:drush][:group]',
  description: 'This is group of the executable binary.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: 'root'
)

attribute(
  'nmddrupal/drush/mode',
  display_name: '[:nmddrupal][:drush][:mode]',
  description: 'This is permissions of the executable binary.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: '755'
)

attribute(
  'nmddrupal/drush/state',
  display_name: '[:nmddrupal][:drush][:state]',
  description: 'Controls runtime action: install, update, or purge',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::drush'],
  default: 'install'
)

grouping(
  'nmddrupal/files',
  title: 'Files attributes',
  description: 'Files recipe attributes'
)

attribute(
  'nmddrupal/files/path',
  display_name: '[:nmddrupal][:files][:path]',
  description: 'This is the root level files directory path.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::files'],
  default: '/default/files'
)

attribute(
  'nmddrupal/files/owner',
  display_name: '[:nmddrupal][:files][:owner]',
  description: 'This is the root level files directory owner.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::files'],
  default: 'root'
)

attribute(
  'nmddrupal/files/group',
  display_name: '[:nmddrupal][:files][:path]',
  description: 'This is the root level files directory path group owner.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::files'],
  default: 'root'
)

attribute(
  'nmddrupal/files/mode',
  display_name: '[:nmddrupal][:files][:mode]',
  description: 'This is the root level files directory mode.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::files'],
  default: '0755'
)

grouping(
  'nmddrupal/database',
  title: 'Files attributes',
  description: 'Files recipe attributes'
)

driver_desc = 'The driver property indicates what Drupal database driver the '
driver_desc << 'connection should use.'
attribute(
  'nmddrupal/database/driver',
  display_name: '[:nmddrupal][:databse][:driver]',
  description: driver_desc,
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::database'],
  default: 'mysql'
)

attribute(
  'nmddrupal/database/database',
  display_name: '[:nmddrupal][:database][:database]',
  description: 'The name of the database.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::database'],
  default: 'example'
)

attribute(
  'nmddrupal/database/username',
  display_name: '[:nmddrupal][:database][:username]',
  description: 'The database username for the site.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::database'],
  default: 'drupal_db_user'
)

attribute(
  'nmddrupal/database/password',
  display_name: '[:nmddrupal][:database][:password]',
  description: 'The database user\'s password for the site.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::database'],
  default: 'randompassword'
)

attribute(
  'nmddrupal/database/host',
  display_name: '[:nmddrupal][:database][:host]',
  description: 'The host for the database.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::database'],
  default: 'localhost'
)

attribute(
  'nmddrupal/database/prefix',
  display_name: '[:nmddrupal][:database][:prefix]',
  description: 'An optional prefix for the database tables.',
  type: 'string',
  required: 'recommended',
  recipes: ['nmddrupal::database'],
  default: ''
)
