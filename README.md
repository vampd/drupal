[![Build Status](https://travis-ci.org/newmediadenver/drupal.svg?branch=3.x)](https://travis-ci.org/newmediadenver/drupal)

New Media Denver's nmd-drupal cookbook
=============================

nmd-drupal (3.0.0) Manages Drupal.

Manages the installation and configuration of Drupal.

Requirements
------------

### Platforms

`ubuntu >= 12.04`

`centos >= 6.0`

### Dependencies


Attributes
----------

drupal/files/path: 
  display_name: "[:drupal][:files][:path]"
  description: This is the root level files directory path.
  type: string
  required: recommended
  recipes:
  - nmd-drupal::files
  default: "/default/files"
  choice: []
  calculated: false
drupal/files/owner: 
  display_name: "[:drupal][:files][:owner]"
  description: This is the root level files directory owner.
  type: string
  required: recommended
  recipes:
  - nmd-drupal::files
  default: root
  choice: []
  calculated: false
drupal/files/group: 
  display_name: "[:drupal][:files][:path]"
  description: |-
    This is the root level files directory path group owner
              .
  type: string
  required: recommended
  recipes:
  - nmd-drupal::files
  default: root
  choice: []
  calculated: false
drupal/files/mode: 
  display_name: "[:drupal][:files][:mode]"
  description: This is the root level files directory mode.
  type: string
  required: recommended
  recipes:
  - nmd-drupal::files
  default: '755'
  choice: []
  calculated: false


Recipes
-------

nmd-drupal::default: Manages Drupal.
nmd-drupal::files: Manages files
nmd-drupal::30ish: Goes beep


Testing and Utility
-------

    rake foodcritic
        Lint Chef cookbooks
    
    rake integration
        Alias for kitchen:all
    
    rake kitchen:all
        Run all test instances
    
    rake kitchen:files-centos-64
        Run files-centos-64 test instance
    
    rake kitchen:files-ubuntu-1204
        Run files-ubuntu-1204 test instance
    
    rake kitchen:files-ubuntu-1404
        Run files-ubuntu-1404 test instance
    
    rake readme
        Generate the Readme.md file.
    
    rake rubocop
        Run RuboCop style and lint checks
    
    rake spec
        Run ChefSpec examples
    
    rake test
        Run all tests
    
    

License and Authors
------------------

Authors:: 
*   Alex Knoll
*   Tim Whitney
*   Kevin Bridges
*   David Arnold
*   Chris Caldwell
*   Rick Manelius
*   arknoll
*   Caleb Thorne
*   bryonurbanec
*   tannerjfco


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
