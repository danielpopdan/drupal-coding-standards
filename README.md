About
=====

This is a git pre-push hook intended to help Drupal developers to keep the code
base clean by performing a scan with Drupal Coder whenever new code is pushed to
the repository. When any coding standards violations are present the push is 
rejected, allowing the developer to fix the code before making it public.

To increase performance only the changed files are checked when new code is
pushed to repository. Note that the full file will be checked, so if you didn't
use this library from the beginning you can get coding violations from the past.

With this library you can make the code review phase more quickly, letting the 
reviewers just to concentrate on the logic of the project. If you don't want to
use this anymore, you can easily delete the `pre-push` hook from `.git/hooks/` 
directory. If you notice any issue, please let us know on [GitHub issue page](https://github.com/danielpopdan/drupal-coding-standards/issues)
of the project.


Installation
=====

Add Drupal Coding Standards to your composer.json:

*Option 1:* 

```
composer require drupal-standards/drupal-coding-standards:dev-master
```

*Option 2:*

**`composer.json`**

```
{
  "require": {
    "drupal-standards/drupal-coding-standards": "dev-master"
  }
}
```

A post install scripts is needed to symlink the pre-push file of the 
library with the git pre-push file and to register the Drupal Coding Standards.
Because of security issues, composer doesn't execute post install scripts of 
dependencies, so you will have to add this script to your composer.json. Please 
add the [post install script](https://github.com/danielpopdan/drupal-coding-standards/blob/master/scripts/composer/post-install.sh)
to scripts/composer directory of your Drupal project root, in the
post-install.sh file. 

```
#!/bin/sh

# Symlink the git pre-push hook to its destination.
if [ ! -h ".git/hooks/pre-push" ] ; then
  ln -s "../../vendor/drupal-pfrenssen/phpcs-pre-push/pre-push" ".git/hooks/pre-push"
  vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
fi
```

After that you will have to make this script file executable:

```
chmod u+x scripts/composer/post-install.sh
```

Please add the script to your composer.json file:
 
```
"scripts": {
    "post-install-cmd": "scripts/composer/post-install.sh"
}
```

The final step of the installation is to add the [Drupal Code Sniffer Ruleset](https://github.com/danielpopdan/drupal-coding-standards/blob/master/drupalcs.xml),
because you probably have some files you don't want to be parsed.

The rule set contains two very important tags, <exclude-pattern> and <arg>.

*<exclude-pattern>*
With this tag you can exclude any file you want, by default all core files and 
features generated files are excluded, but you can add other files too, like a 
custom setting php, or you can totally exclude all files of a type, like CSS,
because your css is generated by SAS. 

*<arg>*
For <arg> you can pass a name and a value which will be passed to Code Sniffer, 
for example: 

```
<arg name="standard" value="Drupal"/>
```

That will be passed as `--standard=Drupal`. 


