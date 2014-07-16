[![Build Status](https://travis-ci.org/newmediadenver/drupal.svg?branch=3.x)](https://travis-ci.org/newmediadenver/drupal)

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


Attributes
----------

nmddrupal/path:
  display_name: "[:nmddrupal][:path]"
  description: The path of the code being requested.
  type: string
  required: required
  recipes:
  - nmddrupal::deploy_code
  default: "/srv/www/example"
  choice: []
  calculated: false
nmddrupal/owner:
  display_name: "[:nmddrupal][:owner]"
  description: The owner of the directory the code is being deployed to.
  type: string
  required: required
  recipes:
  - nmddrupal::deploy_code
  default: www-data
  choice: []
  calculated: false
nmddrupal/group:
  display_name: "[:nmddrupal][:group]"
  description: The group of the directory the code is being deployed to.
  type: string
  required: required
  recipes:
  - nmddrupal::deploy_code
  default: www-data
  choice: []
  calculated: false
nmddrupal/mode:
  display_name: "[:nmddrupal][:revision]"
  description: The number of releases to keep.
  type: string
  required: required
  recipes:
  - nmddrupal::deploy_code
  default: 7.x
  choice: []
  calculated: false
nmddrupal/drush/revision:
  display_name: "[:nmddrupal][:drush][:revision]"
  description: This is the version of drush to install.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: 6.3.0
  choice: []
  calculated: false
nmddrupal/drush/repository:
  display_name: "[:nmddrupal][:drush][:repository]"
  description: This is the code repository to reference.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: https://github.com/drush-ops/drush.git
  choice: []
  calculated: false
nmddrupal/drush/dir:
  display_name: "[:nmddrupal][:drush][:dir]"
  description: This folder stores the clone repository.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: "/opt/drush"
  choice: []
  calculated: false
nmddrupal/drush/executable:
  display_name: "[:nmddrupal][:drush][:executable]"
  description: This is the symlinked file to the drush binary.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: "/usr/bin/drush"
  choice: []
  calculated: false
nmddrupal/drush/owner:
  display_name: "[:nmddrupal][:drush][:owner]"
  description: This is owner of the executable binary.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: root
  choice: []
  calculated: false
nmddrupal/drush/group:
  display_name: "[:nmddrupal][:drush][:group]"
  description: This is group of the executable binary.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: root
  choice: []
  calculated: false
nmddrupal/drush/mode:
  display_name: "[:nmddrupal][:drush][:mode]"
  description: This is permissions of the executable binary.
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: '755'
  choice: []
  calculated: false
nmddrupal/drush/state:
  display_name: "[:nmddrupal][:drush][:state]"
  description: 'Controls runtime action: install, update, or purge'
  type: string
  required: recommended
  recipes:
  - nmddrupal::drush
  default: install
  choice: []
  calculated: false
nmddrupal/files/path:
  display_name: "[:nmddrupal][:files][:path]"
  description: This is the root level files directory path.
  type: string
  required: recommended
  recipes:
  - nmddrupal::files
  default: "/default/files"
  choice: []
  calculated: false
nmddrupal/files/owner:
  display_name: "[:nmddrupal][:files][:owner]"
  description: This is the root level files directory owner.
  type: string
  required: recommended
  recipes:
  - nmddrupal::files
  default: root
  choice: []
  calculated: false
nmddrupal/files/group:
  display_name: "[:nmddrupal][:files][:path]"
  description: This is the root level files directory path group owner.
  type: string
  required: recommended
  recipes:
  - nmddrupal::files
  default: root
  choice: []
  calculated: false
nmddrupal/files/mode:
  display_name: "[:nmddrupal][:files][:mode]"
  description: This is the root level files directory mode.
  type: string
  required: recommended
  recipes:
  - nmddrupal::files
  default: '0755'
  choice: []
  calculated: false


Recipes
-------

nmddrupal::default: Manages Drupal.
nmddrupal::delete_code: An example recipe that illustrates using the nmddrupal_code
  LWRP to delete Drupal code.
nmddrupal::deploy_code: An example recipe that illustrates using the nmddrupal_code
  LWRP to deploy Drupal code.
nmddrupal::files: Manages files


Testing and Utility
-------

    rake foodcritic
        Run Foodcritic lint checks

    rake integration
        Alias for kitchen:all

    rake kitchen:all
        Run all test instances

    rake kitchen:default-centos-65-virtualbox
        Run default-centos-65-virtualbox test instance

    rake kitchen:default-centos-65-vmware
        Run default-centos-65-vmware test instance

    rake kitchen:default-ubuntu-1404-virtualbox
        Run default-ubuntu-1404-virtualbox test instance

    rake kitchen:default-ubuntu-1404-vmware
        Run default-ubuntu-1404-vmware test instance

    rake kitchen:delete-code-centos-65-virtualbox
        Run delete-code-centos-65-virtualbox test instance

    rake kitchen:delete-code-centos-65-vmware
        Run delete-code-centos-65-vmware test instance

    rake kitchen:delete-code-ubuntu-1404-virtualbox
        Run delete-code-ubuntu-1404-virtualbox test instance

    rake kitchen:delete-code-ubuntu-1404-vmware
        Run delete-code-ubuntu-1404-vmware test instance

    rake kitchen:deploy-code-centos-65-virtualbox
        Run deploy-code-centos-65-virtualbox test instance

    rake kitchen:deploy-code-centos-65-vmware
        Run deploy-code-centos-65-vmware test instance

    rake kitchen:deploy-code-ubuntu-1404-virtualbox
        Run deploy-code-ubuntu-1404-virtualbox test instance

    rake kitchen:deploy-code-ubuntu-1404-vmware
        Run deploy-code-ubuntu-1404-vmware test instance

    rake kitchen:drush-centos-65-virtualbox
        Run drush-centos-65-virtualbox test instance

    rake kitchen:drush-centos-65-vmware
        Run drush-centos-65-vmware test instance

    rake kitchen:drush-ubuntu-1404-virtualbox
        Run drush-ubuntu-1404-virtualbox test instance

    rake kitchen:drush-ubuntu-1404-vmware
        Run drush-ubuntu-1404-vmware test instance

    rake kitchen:files-centos-65-virtualbox
        Run files-centos-65-virtualbox test instance

    rake kitchen:files-centos-65-vmware
        Run files-centos-65-vmware test instance

    rake kitchen:files-ubuntu-1404-virtualbox
        Run files-ubuntu-1404-virtualbox test instance

    rake kitchen:files-ubuntu-1404-vmware
        Run files-ubuntu-1404-vmware test instance

    rake readme
        Generate the Readme.md file.

    rake rubocop
        Run RuboCop style and lint checks

    rake spec
        Run ChefSpec examples.

    rake test
        Run all tests



License and Authors
------------------

The following users have contributed to this code:
*   ["https://github.com/cyberswat", "Kevin Bridges"]
*   ["https://github.com/arknoll", "Alex Knoll"]
*   ["https://github.com/DavidXArnold", "David Arnold"]
*   ["https://github.com/rickmanelius", "Rick Manelius"]
*   ["https://github.com/timodwhit", "Tim Whitney"]
*   ["https://github.com/tannerjfco", "tannerjfco"]
*   ["https://github.com/draenen", "Caleb Thorne"]
*   ["https://github.com/b-ry", "bryonurbanec"]


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
