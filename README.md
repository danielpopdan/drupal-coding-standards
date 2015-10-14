About
=====

This is a git pre-push hook intended to help Drupal developers to keep the base 
clean by performing a scan with Drupal Coder whenever new code is
pushed to the repository. When any coding standards violations are present the
push is rejected, allowing the developer to fix the code before making it
public.

To increase performance only the changed files are checked when new code is
pushed to repository. Note that the full file will be checked, so if you didn't
use this library from the beginning you can get errors from the past.

With this library you can make the code review step more quickly, letting the 
reviewers just to concentrate on the logic of the project. If you don't want to
use this anymore, you can easily delete the `pre-push` hook from `.git/hooks/` 
folder. If you notice any issue, please let us know on GitHub issue page of the
project `https://github.com/danielpopdan/drupal-coding-standards/issues` .


Installation
=====

Add Drupal Coding Standards to your composer.json:

*Option 1* 

```
composer require drupal-standards/drupal-coding-standards:dev-master
```

*Option 2*

**`composer.json`**

```
{
  "require": {
    "drupal-standards/drupal-coding-standards": "dev-master"
  }
}
```

Some post install scripts are needed to symlink the pre-push file of the 
library with your pre-push file. Because of security issues, composer doesn't 
executes post install scripts of dependencies, so you will have to add
those scripts to your composer.json. Please copy the [post install script](https://github.com/danielpopdan/drupal-coding-standards/blob/master/scripts/composer/post-install.sh)
to scripts/composer directory of your Drupal project. 

```
#!/bin/sh

# Symlink the git pre-push hook to its destination.
if [ ! -h ".git/hooks/pre-push" ] ; then
  ln -s "../../vendor/drupal-pfrenssen/phpcs-pre-push/pre-push" ".git/hooks/pre-push"
  vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
fi
```

After that you will have to make this script file executable.

```
chmod u+x scripts/composer/post-install.sh
```

After that, please add the script to your composer.json file.
 
```
"scripts": {
    "post-install-cmd": "scripts/composer/post-install.sh"
}
```


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
