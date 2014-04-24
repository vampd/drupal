Drupal Cookbook
===============
This cookbook installs a Drupal site on a LAMP stack.

https://travis-ci.org/newmediadenver/drupal.svg?branch=2.x

Usage
-----
This cookbook has been designed to work with [drupal-lamp](http://github.com/newmediadenver/drupal-lamp).

## JSON Explained
This JSON is found in the drupal-lamp repo under infrastructure/drupal_lamp.json.

```
"drupal": { # Name of the cookbook
  "sites": { # Handling of sites
    "example": {  # site name
      "active": true, # true or false
      "deploy": {
        "action": ["deploy", "import", "update"], # see "Available Deploy Actions"
        "releases": 1 # number of git releases to store (in addition to the active release)
      },
      "drush_make": { # Use drush make (See "Using Drush Make")
        "api": "2",
        "files": { # Pull in all drush make files needed for the make
          "default": "build-profile.make",
          "core": "drupal-org-core.make"
        },
        "template": false # Use a template or use the "default" file
      },
      "drupal": {
        "version": "7.0", # drupal version 8.0, 7.0 or 6.0
        "install": { # key->value pair passed to 'drush site-install'
          "install_configure_form.update_status_module": "'array(FALSE,FALSE)'",
          "--clean-url": 1 # enable clean urls on site install
        },
        "settings": {
          "profile": "standard", # if action is clean, this install profile will be installed
          "files": "sites/default/files", # location of the files directory
          "cookbook": "drupal", # the name of this cookbook
          "settings": { # See "Working with multiple settings.php"
            "default": {
              "location": "sites/default/settings.php" # location of the settings.php file
            },
          },
          "db_name": "example", # database name
          "db_host": "localhost", # database host
          "db_prefix": "", # database prefix
          "db_driver": "mysql", # database driver
          "db_file": "/vagrant/backup.sql" # path of db file to be imported, if "action" has
          "import" .
        }
      },
      "repository": {
        "host": "github.com",
        "uri": "https://github.com/drupal/drupal.git",
        "revision": "7.26", # branch, tag, or hash
        "shallow_clone": false # Indicates that the clone depth is set to 5. Default value: false.
      },
      # Apache configuration options
      "web_app": { # See "Web App Config Options"
        "80": { # port (Necessary)
          "server_name": "drupal.local", (Necessary)
          "rewrite_engine": "On", (Necessary)
          "docroot": "/srv/www/example/current", (Necessary)
        }
      }
    }
  }
}
````

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
