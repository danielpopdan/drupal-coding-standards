About
=====

This is a git pre-push hook intended to help developers keep their Drupal code
base clean by performing a scan with Drupal Coder whenever new code is
pushed to the repository. When any coding standards violations are present the
push is rejected, allowing the developer to fix the code before making it
public.

To increase performance only the changed files are checked when new code is
pushed to an existing branch.  Whenever a new branch is pushed, a full coding
standards check is performed.

If your project enforces the use of a coding standard then this will help with
that, but it is easy to circumvent since the pre-push hook can simply be
deleted. You might want to implement similar functionality in a pre-receive
hook on the server side, or include a coding standards check in your continuous
integration pipeline.


Usage
=====

Add Coder and this gist to your composer.json:

**`composer.json`**

```
{
  "require-dev": {
    "drupal-pfrenssen/phpcs-pre-push": "1.0"
  },
  "repositories": [
    {
      "type": "package",
      "package": {
        "name": "drupal-pfrenssen/phpcs-pre-push",
        "version": "1.0",
        "source": {
          "url": "https://gist.github.com/990f9521f84d693ccd1a.git",
          "type": "git",
          "reference": "master"
        }
      }
    }
  ],
  "scripts": {
    "post-install-cmd": "scripts/composer/post-install.sh"
  },
  "require": {
    "drupal/coder": "^7.2"
  }
}

For Drupal 8 please include "drupal/coder": "^8.2".
```

Create a post-install script that will symlink the pre-push inside your git
repository whenever you do a `composer install`:

**`scripts/composer/post-install.sh`**

```
#!/bin/sh

# Symlink the git pre-push hook to its destination.
if [ ! -h ".git/hooks/pre-push" ] ; then
  ln -s "../../vendor/drupal-pfrenssen/phpcs-pre-push/pre-push" ".git/hooks/pre-push"
  vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
fi
```

Create a [PHP CodeSniffer ruleset](http://pear.php.net/manual/en/package.php.php-codesniffer.annotated-ruleset.php)
containing your custom coding standard:

**`phpcs.xml`**

```
<?xml version="1.0" encoding="UTF-8"?>
<!-- See http://pear.php.net/manual/en/package.php.php-codesniffer.annotated-ruleset.php -->
<ruleset name="MyRuleset">
  <description>Custom coding standard for my project</description>

  <rule ref="PSR2" />

  <!--
    Scan the entire root folder by default. If your application code is
    contained in a subfolder such as `lib/` or `src/` you can use that instead.
   -->
  <file>.</file>

  <!-- Minified files don't have to comply with coding standards. -->
  <exclude-pattern>*.min.css</exclude-pattern>
  <exclude-pattern>*.min.js</exclude-pattern>

  <!-- Exclude files that do not contain PHP, Javascript or CSS code. -->
  <exclude-pattern>*.json</exclude-pattern>
  <exclude-pattern>*.sh</exclude-pattern>
  <exclude-pattern>*.xml</exclude-pattern>
  <exclude-pattern>*.yml</exclude-pattern>
  <exclude-pattern>*.css</exclude-pattern>
  <exclude-pattern>composer.lock</exclude-pattern>

  <!-- Exclude the `vendor` folder. -->
  <exclude-pattern>vendor/</exclude-pattern>
  <!-- Exclude the drupal default folders. -->
  <exclude-pattern>includes/</exclude-pattern>
  <exclude-pattern>misc/</exclude-pattern>
  <exclude-pattern>modules/</exclude-pattern>
  <exclude-pattern>profiles/minimal/</exclude-pattern>
  <exclude-pattern>profiles/standard/</exclude-pattern>
  <exclude-pattern>profiles/testing/</exclude-pattern>
  <exclude-pattern>scripts/</exclude-pattern>
  <exclude-pattern>sites/all/modules/contrib/</exclude-pattern>
  <exclude-pattern>sites/all/libraries/</exclude-pattern>
  <exclude-pattern>sites/default/</exclude-pattern>
  <exclude-pattern>themes/</exclude-pattern>
  <exclude-pattern>authorize.php</exclude-pattern>
  <exclude-pattern>cron.php</exclude-pattern>
  <exclude-pattern>index.php</exclude-pattern>
  <exclude-pattern>install.php</exclude-pattern>
  <exclude-pattern>update.php</exclude-pattern>
  <exclude-pattern>xmlrpc.php</exclude-pattern>

  <!-- PHP CodeSniffer command line options -->
  <arg name="extensions" value="php,js,module,theme,info,install,inc"/>
  <arg name="report" value="full"/>
  <arg name="standard" value="Drupal"/>
  <arg value="p"/>
</ruleset>
```

Now run make the `post-install.sh` script executable and run `composer install`
and you're set! This will download the required packages, and will put the git
pre-push hook in place.

```
$ chmod u+x scripts/composer/post-install.sh
$ composer install
```
