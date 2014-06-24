# encoding: utf-8
name 'nmddrupal'
maintainer 'New Media Denver'
maintainer_email 'support@newmediadenver.com'
license 'Apache 2.0'
description 'Installs/Configures nmddrupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.0'
supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 6.0'

desc = 'Manages Drupal.'
description desc

depends 'git'
depends 'ssh_known_hosts', '~> 1.1.0'

long_description 'Manages the installation and configuration of Drupal.'
recipe 'nmddrupal::default', desc
recipe 'nmddrupal::deploy', 'Deploys a Drupal Site'
recipe 'nmddrupal::files', 'Manages files'

grouping(
  'nmddrupal/deploy',
  title: 'Deploy attributes',
  description: 'Deploy recipe attributes'
)
attribute(
  'nmddrupal/deploy/base',
  display_name: '[:nmddrupal][:server][:base]',
  description: 'This is the base directory for all sites.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: '/srv/www'
)
attribute(
  'nmddrupal/deploy/web_user',
  display_name: '[:nmddrupal][:server][:users][:web]',
  description: 'This is the linux user and group which owns the site.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: 'www-data:www-data'
)
attribute(
  'nmddrupal/deploy/files_user',
  display_name: '[:nmddrupal][:server][:users][:files]',
  description: 'This is the linux user and group which owns the files.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: 'www-data:www-data'
)
attribute(
  'nmddrupal/deploy/action',
  display_name: '[:nmddrupal][:sites][SITE][:deploy][:action]',
  description: 'Site actions. (e.g., deploy)',
  type: 'string',
  recipes: ['nmddrupal::deploy'],
  choice: ['deploy'],
  default: ''
)
attribute(
  'nmddrupal/deploy/releases',
  display_name: '[:nmddrupal][:sites][SITE][:deploy][:releases]',
  description: 'The number of previous deployed releases to keep in the releases
   folder.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: '5'
)
attribute(
  'nmddrupal/deploy/host',
  display_name: '[:nmddrupal][:sites][SITE][:repository][:host]',
  description: 'Host of git repository.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: 'github.com'
)
attribute(
  'nmddrupal/deploy/uri',
  display_name: '[:nmddrupal][:sites][SITE][:repository][:uri]',
  description: 'Git repository uri.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: 'https://github.com/drupal/drupal.git'
)
attribute(
  'nmddrupal/deploy/revision',
  display_name: '[:nmddrupal][:sites][SITE][:repository][:revision]',
  description: 'Git repository revision.',
  type: 'string',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: '7.28'
)
attribute(
  'nmddrupal/deploy/shallow_clone',
  display_name: '[:nmddrupal][:sites][SITE][:repository][:shallow_clone]',
  description: 'Whether to perform a git shallow clone or not.',
  type: 'boolean',
  required: 'required',
  recipes: ['nmddrupal::deploy'],
  default: 'false'
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
  'nmddrupal/drush/dir',
  display_name: '[:nmddrupal][:drush][:dir]',
  description: 'This folder stores the clone repository.',
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
  description: 'This is the root level files directory path group owner
  .',
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
