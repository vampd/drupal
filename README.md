Drupal Cookbook
===============
This cookbook deploys, installs, imports, and/or updates a Drupal site on a LAMP stack.
This cookbook looks to be a full featured deployment strategy for a drupal site
without the need to pass the napkin.

This cookbook is a fork of [drupal](http://github.com/newmediadenver/drupal) from an
earlier release and is now a separate project.

Usage
-----
This cookbook is designed and featurized to work with [vampd](http://github.com/vampd/vampd).

The cookbook does three top level categories: Server, Drush and Sites:

### The default attributes for `server` are:
```
[:server][:web_user] = 'www-data'
[:server][:web_group] = 'www-data'
[:server][:base] = '/srv/www'
[:server][:assets] = '/assets'
```

### The default attributes for `drush` are:
```
[:drush][:revision] = '6.2.0'
[:drush][:repository] = 'https://github.com/drush-ops/drush.git'
[:drush][:dir] = '/opt/drush'
[:drush][:executable] = '/usr/bin/drush'
```

### The default attributes for `sites` are:

`sites` is an array of sites that is looped over and given default values. `site_name`
is the id of the of the site being looped over.
```

[:sites][site_name][:active] = 0 // Can be true or false
[:sites][site_name][:deploy][:action] = [] // See 'Available Deploy Actions'
[:sites][site_name][:deploy][:releases] = 5 // Number of git releases.

# default to bringing in latest drupal
[:sites][site_name][:repository][:host] = 'github.com'
[:sites][site_name][:repository][:uri] = 'https://github.com/drupal/drupal.git'
[:sites][site_name][:repository][:revision] = '7.26'
[:sites][site_name][:repository][:shallow_clone] = false

[:sites][site_name][:drupal][:version] = '7.26' // Drupal version 8.0, 7.0 or 6.0
[:sites][site_name][:drupal][:registry_rebuild] = false // Whether or not to download and run drush rr.
[:sites][site_name][:drupal][:install]['install_configure_form.update_status_module'] = "'array(FALSE,FALSE)'" // Install flags
[:sites][site_name][:drupal][:install]['--clean-url'] = 1

# Set up the docroot to be used as a default
[:sites][site_name][:drupal][:settings][:profile] = 'standard' // If action includes install, this profile will be installed.
[:sites][site_name][:drupal][:settings][:files] = "#{docroot_before}sites/default/files" // Where the sites live
[:sites][site_name][:drupal][:settings][:cookbook] = 'drupal'
[:sites][site_name][:drupal][:settings][:settings][:default][:location] = "#{docroot_before}sites/default/settings.php"
[:sites][site_name][:drupal][:settings][:settings][:default][:ignore] = false
[:sites][site_name][:drupal][:settings][:db_name] = site_name.gsub('-', '_')
[:sites][site_name][:drupal][:settings][:db_host] = 'localhost'
[:sites][site_name][:drupal][:settings][:db_prefix] = ''
[:sites][site_name][:drupal][:settings][:db_driver] = 'mysql'
[:sites][site_name][:web_app]['80'][:server_name] = "#{site_name}.local"
[:sites][site_name][:web_app]['80'][:rewrite_engine] = 'On'
[:sites][site_name][:web_app]['80'][:docroot] = "#{node[:drupal][:server][:base]}/#{site_name}/current#{docoot_after}"
[:sites][site_name][:web_app]['80'][:error_log] = "/var/log/apache2/#{site_name}-error.log"

[:sites][site_name][:drupal_user][:id] = site_name
[:sites][site_name][:drupal_user][:db_user] = 'drupal'
[:sites][site_name][:drupal_user][:db_password] = 'drupal'
[:sites][site_name][:drupal_user][:admin_user] = 'admin'
[:sites][site_name][:drupal_user][:admin_pass] = 'admin'
[:sites][site_name][:drupal_user][:update_password] = true
```
## Available Deploy Actions
#### deploy
deploy will pull down a fresh copy of your repo.

#### install
install will run drush site-install for the given install profile

#### import
This will import an existing database backup for your site. *If this is set, you will need to have a ```"db_file"``` specified.*

**Example:**  Files placed in the same directory as the Vagrantfile, can be found at /vagrant on the provisioned machine. Therefore, if your file was ```backup.sql``` and was at the same level as the ```VagrantFile```, then you would simply put ```"db_file":"/vagrant/backup.sql"``` in the json.

#### update
Will run:
````
drush updb -y; drush cc all
````

## Using Drush Make

Drush make will build the site out of a drupal profile hosted in a git repo.

**There are two options to use:**
#### Template
This will create the build-profile.make file out of a template. This is extremely helpful to use when working in teams that need to change the location of the profile specified in the build.make file.

**Example:**

```
"drush_make": {
  "api": "2",
  "files": {
    "core": "drupal-org-core.make"
  },
  "template": true
},
```

##### Default
This will use the ```default``` file specified to run the command ```drush make```.
**Example:**

```
"drush_make": {
  "api": "2",
  "files": {
    "default": "build-profile.make" # Name this appropriate to the name of the profile
    "core": "drupal-org-core.make"
  },
  "template": true
},
```
### Adding Drush make arguments

```
"drush_make": {
  "api": "2",
  "files": {
    "default": "build-profile.make" # Name this appropriate to the name of the profile
    "core": "drupal-org-core.make"
  },
  "arguments": { # Add drush make arguments
    "--working-copy" # Example argument
  },
  "template": true
},
```
## Working with Multiple settings.php
The drupal cookbook allows for the handling of multiple settings.php files. This is beneficial because you can control settings for different environments via the inclusion of the files in the default settings.php.

```
"settings": {
  "default": { # Required
    "location": "sites/default/settings.php" # location of the settings.php file
  },
  # use this section if you want to create a settings.php file from a template
  # that will be included at the end of the default settings.php
  "example_template": { # Optional. Can be named anything
    "location": "sites/default/example.settings.php",
    "template": "example.settings.php.erb" #if filled out will look for a template in the recipe
  },
  # use this section if you want to include an additional settings.php
  # file onto the end of the default settings.php file
  "example_static": { # Optional. Can be named anything
    "location": "profiles/standard/standard.settings.php"
  }
}
```

## Web App Config Options
These are the options that exposed to the drupal cookbook for editing in the sites json.

```
  "web_app": {
    "80": { # port
      "server_name": "drupal.local",
      "rewrite_engine": "On",
      "docroot": "/srv/www/example/current",
      "server_name": "",
      "server_aliases": "",
      "rewrite_log": "",
      "rewrite_log_level": "",
      "directories": "",
      "rewrite": "",
      "log_level": "",
      "error_log": "",
      "custom_log": "",
      "transfer_log": "",
      "set_env_if": "",
      "redirect": ""
    },
    # include if you need https
    "443": {
    	"server_name": "drupal.local",
      "rewrite_engine": "On",
      "docroot": "/srv/www/example/current",
      "server_name": "",
      "server_aliases": "",
      "rewrite_log": "",
      "rewrite_log_level": "",
      "directories": "",
      "rewrite": "",
      "log_level": "",
      "error_log": "",
      "custom_log": "",
      "transfer_log": "",
      "set_env_if": "",
      "redirect": "",
      "ssl": {
        "ssl_engine": "",
        "ssl_protocol": "",
        "ssl_cipher_suite": "",
        "ssl_certificate_file": "",
        "ssl_certificate_key_file": ""
      }
    }
````

Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
