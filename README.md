New Media Denver's nmddrupal cookbook
=============================

nmddrupal (3.0.0) Manages Drupal.

Manages the installation and configuration of Drupal.

Requirements
------------

### Platforms

`ubuntu >= 12.04`

`centos >= 6.0`

### Dependencies

`git >= 0.0.0`

`ssh_known_hosts ~> 1.1.0`

`mysql ~> 5.3.6`

`database ~> 2.2.0`


Attributes
----------

    nmddrupal/path
      calculated: false
      choice: []
      default: /srv/www/example
      description: The path of the code being requested.
      display_name: [:nmddrupal][:path]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/owner
      calculated: false
      choice: []
      default: www-data
      description: The owner of the directory the code is being deployed to.
      display_name: [:nmddrupal][:owner]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/group
      calculated: false
      choice: []
      default: www-data
      description: The group of the directory the code is being deployed to.
      display_name: [:nmddrupal][:group]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/mode
      calculated: false
      choice: []
      default: 493
      description: The mode of the directory the code is being deployed to.
      display_name: [:nmddrupal][:mode]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/repository
      calculated: false
      choice: []
      default: http://git.drupal.org/project/drupal.git
      description: The repository to request the code from.
      display_name: [:nmddrupal][:repository]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/revision
      calculated: false
      choice: []
      default: 7.x
      description: The repository revision to request the code from.
      display_name: [:nmddrupal][:revision]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/releases
      calculated: false
      choice: []
      default: 7.x
      description: The number of releases to keep.
      display_name: [:nmddrupal][:releases]
      type: string
      recipes: ["nmddrupal::deploy_code"]
      required: required

    nmddrupal/drush/revision
      calculated: false
      choice: []
      default: 6.3.0
      description: This is the version of drush to install.
      display_name: [:nmddrupal][:drush][:revision]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/repository
      calculated: false
      choice: []
      default: https://github.com/drush-ops/drush.git
      description: This is the code repository to reference.
      display_name: [:nmddrupal][:drush][:repository]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/path
      calculated: false
      choice: []
      default: /opt/drush
      description: The path to deploy to.
      display_name: [:nmddrupal][:drush][:path]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/executable
      calculated: false
      choice: []
      default: /usr/bin/drush
      description: This is the symlinked file to the drush binary.
      display_name: [:nmddrupal][:drush][:executable]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/owner
      calculated: false
      choice: []
      default: root
      description: This is owner of the executable binary.
      display_name: [:nmddrupal][:drush][:owner]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/group
      calculated: false
      choice: []
      default: root
      description: This is group of the executable binary.
      display_name: [:nmddrupal][:drush][:group]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/mode
      calculated: false
      choice: []
      default: 755
      description: This is permissions of the executable binary.
      display_name: [:nmddrupal][:drush][:mode]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/drush/state
      calculated: false
      choice: []
      default: install
      description: Controls runtime action: install, update, or purge
      display_name: [:nmddrupal][:drush][:state]
      type: string
      recipes: ["nmddrupal::drush"]
      required: recommended

    nmddrupal/files/path
      calculated: false
      choice: []
      default: /default/files
      description: This is the root level files directory path.
      display_name: [:nmddrupal][:files][:path]
      type: string
      recipes: ["nmddrupal::files"]
      required: recommended

    nmddrupal/files/owner
      calculated: false
      choice: []
      default: root
      description: This is the root level files directory owner.
      display_name: [:nmddrupal][:files][:owner]
      type: string
      recipes: ["nmddrupal::files"]
      required: recommended

    nmddrupal/files/group
      calculated: false
      choice: []
      default: root
      description: This is the root level files directory path group owner.
      display_name: [:nmddrupal][:files][:path]
      type: string
      recipes: ["nmddrupal::files"]
      required: recommended

    nmddrupal/files/mode
      calculated: false
      choice: []
      default: 0755
      description: This is the root level files directory mode.
      display_name: [:nmddrupal][:files][:mode]
      type: string
      recipes: ["nmddrupal::files"]
      required: recommended

    nmddrupal/database/driver
      calculated: false
      choice: []
      default: mysql
      description: The driver property indicates what Drupal database driver the connection should use.
      display_name: [:nmddrupal][:databse][:driver]
      type: string
      recipes: ["nmddrupal::database"]
      required: recommended

    nmddrupal/database/database
      calculated: false
      choice: []
      default: example
      description: The name of the database.
      display_name: [:nmddrupal][:database][:database]
      type: string
      recipes: ["nmddrupal::database"]
      required: recommended

    nmddrupal/database/username
      calculated: false
      choice: []
      default: drupal_db_user
      description: The database username for the site.
      display_name: [:nmddrupal][:database][:username]
      type: string
      recipes: ["nmddrupal::database"]
      required: recommended

    nmddrupal/database/password
      calculated: false
      choice: []
      default: randompassword
      description: The database user's password for the site.
      display_name: [:nmddrupal][:database][:password]
      type: string
      recipes: ["nmddrupal::database"]
      required: recommended

    nmddrupal/database/host
      calculated: false
      choice: []
      default: localhost
      description: The host for the database.
      display_name: [:nmddrupal][:database][:host]
      type: string
      recipes: ["nmddrupal::database"]
      required: recommended

    nmddrupal/database/prefix
      calculated: false
      choice: []
      default: 
      description: An optional prefix for the database tables.
      display_name: [:nmddrupal][:database][:prefix]
      type: string
      recipes: ["nmddrupal::database"]
      required: recommended


Recipes
-------

    nmddrupal::default
      Manages Drupal.

    nmddrupal::delete_code
      An example recipe that illustrates using the nmddrupal_code LWRP to delete Drupal code.

    nmddrupal::deploy_code
      An example recipe that illustrates using the nmddrupal_code LWRP to deploy Drupal code.

    nmddrupal::deploy_mysql
      Example wrapper recipe that creates a mysql database, mysql database user, and sets grants for Drupal.

    nmddrupal::delete_mysql
      Example wrapper recipe that removes a mysql database, user and grants.

    nmddrupal::files
      Manages files

Testing and Utility
-------
    <Rake::Task default => [style, integration:kitchen:all]>

    <Rake::Task integration:kitchen:all => [default-ubuntu-1404-vmware, default-ubuntu-1404-virtualbox, default-centos-65-vmware, default-centos-65-virtualbox, deploy-drush-ubuntu-1404-vmware, deploy-drush-ubuntu-1404-virtualbox, deploy-drush-centos-65-vmware, deploy-drush-centos-65-virtualbox, delete-drush-ubuntu-1404-vmware, delete-drush-ubuntu-1404-virtualbox, delete-drush-centos-65-vmware, delete-drush-centos-65-virtualbox, files-ubuntu-1404-vmware, files-ubuntu-1404-virtualbox, files-centos-65-vmware, files-centos-65-virtualbox, deploy-code-ubuntu-1404-vmware, deploy-code-ubuntu-1404-virtualbox, deploy-code-centos-65-vmware, deploy-code-centos-65-virtualbox, delete-code-ubuntu-1404-vmware, delete-code-ubuntu-1404-virtualbox, delete-code-centos-65-vmware, delete-code-centos-65-virtualbox, deploy-mysql-ubuntu-1404-vmware, deploy-mysql-ubuntu-1404-virtualbox, deploy-mysql-centos-65-vmware, deploy-mysql-centos-65-virtualbox, delete-mysql-ubuntu-1404-vmware, delete-mysql-ubuntu-1404-virtualbox, delete-mysql-centos-65-vmware, delete-mysql-centos-65-virtualbox]>
      Run all test instances

    <Rake::Task integration:kitchen:default-centos-65-virtualbox => []>
      Run default-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:default-centos-65-vmware => []>
      Run default-centos-65-vmware test instance

    <Rake::Task integration:kitchen:default-ubuntu-1404-virtualbox => []>
      Run default-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:default-ubuntu-1404-vmware => []>
      Run default-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:delete-code-centos-65-virtualbox => []>
      Run delete-code-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:delete-code-centos-65-vmware => []>
      Run delete-code-centos-65-vmware test instance

    <Rake::Task integration:kitchen:delete-code-ubuntu-1404-virtualbox => []>
      Run delete-code-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:delete-code-ubuntu-1404-vmware => []>
      Run delete-code-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:delete-drush-centos-65-virtualbox => []>
      Run delete-drush-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:delete-drush-centos-65-vmware => []>
      Run delete-drush-centos-65-vmware test instance

    <Rake::Task integration:kitchen:delete-drush-ubuntu-1404-virtualbox => []>
      Run delete-drush-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:delete-drush-ubuntu-1404-vmware => []>
      Run delete-drush-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:delete-mysql-centos-65-virtualbox => []>
      Run delete-mysql-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:delete-mysql-centos-65-vmware => []>
      Run delete-mysql-centos-65-vmware test instance

    <Rake::Task integration:kitchen:delete-mysql-ubuntu-1404-virtualbox => []>
      Run delete-mysql-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:delete-mysql-ubuntu-1404-vmware => []>
      Run delete-mysql-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:deploy-code-centos-65-virtualbox => []>
      Run deploy-code-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:deploy-code-centos-65-vmware => []>
      Run deploy-code-centos-65-vmware test instance

    <Rake::Task integration:kitchen:deploy-code-ubuntu-1404-virtualbox => []>
      Run deploy-code-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:deploy-code-ubuntu-1404-vmware => []>
      Run deploy-code-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:deploy-drush-centos-65-virtualbox => []>
      Run deploy-drush-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:deploy-drush-centos-65-vmware => []>
      Run deploy-drush-centos-65-vmware test instance

    <Rake::Task integration:kitchen:deploy-drush-ubuntu-1404-virtualbox => []>
      Run deploy-drush-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:deploy-drush-ubuntu-1404-vmware => []>
      Run deploy-drush-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:deploy-mysql-centos-65-virtualbox => []>
      Run deploy-mysql-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:deploy-mysql-centos-65-vmware => []>
      Run deploy-mysql-centos-65-vmware test instance

    <Rake::Task integration:kitchen:deploy-mysql-ubuntu-1404-virtualbox => []>
      Run deploy-mysql-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:deploy-mysql-ubuntu-1404-vmware => []>
      Run deploy-mysql-ubuntu-1404-vmware test instance

    <Rake::Task integration:kitchen:files-centos-65-virtualbox => []>
      Run files-centos-65-virtualbox test instance

    <Rake::Task integration:kitchen:files-centos-65-vmware => []>
      Run files-centos-65-vmware test instance

    <Rake::Task integration:kitchen:files-ubuntu-1404-virtualbox => []>
      Run files-ubuntu-1404-virtualbox test instance

    <Rake::Task integration:kitchen:files-ubuntu-1404-vmware => []>
      Run files-ubuntu-1404-vmware test instance

    <Rake::Task readme => [utility:readme]>
      Generate README.md

    <Rake::Task spec => [style:spec]>
      Run rspec tests.

    <Rake::Task style => [style:chef, style:ruby, style:spec]>
      Run all style checks

    <Rake::Task style:chef => []>
      Run Chef style checks

    <Rake::Task style:ruby => []>
      Run Ruby style checks

    <Rake::Task style:ruby:auto_correct => []>
      Auto-correct RuboCop offenses

    <Rake::Task style:spec => []>
      Run rspec tests.

    <Rake::Task travis => [style]>
      Run all tests on Travis

    <Rake::Task utility:readme => []>
      Generate the Readme.md file.

License and Authors
------------------

The following engineers have contributed to this code:
<<<<<<< HEAD
 * [Kevin Bridges](https://github.com/cyberswat) - 99 commits
=======
 * [Kevin Bridges](https://github.com/cyberswat) - 88 commits
>>>>>>> Updating readme.
 * [Alex Knoll, arknoll](https://github.com/arknoll) - 75 commits
 * [David Arnold](https://github.com/DavidXArnold) - 28 commits
 * [Rick Manelius](https://github.com/rickmanelius) - 17 commits
 * [Tim Whitney](https://github.com/timodwhit) - 44 commits
 * [Chris Caldwell](https://github.com/chrisolof) - 11 commits
 * [tannerjfco](https://github.com/tannerjfco) - 1 commits
 * [Caleb Thorne](https://github.com/draenen) - 2 commits
 * [bryonurbanec](https://github.com/b-ry) - 1 commits

Copyright:: 2014, NewMedia Denver

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
