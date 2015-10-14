#!/bin/sh

# Symlink the git pre-push hook to its destination.
if [ ! -h ".git/hooks/pre-push" ] ; then
  ln -s "../../vendor/drupal-standards/drupal-coding-standards/pre-push" ".git/hooks/pre-push"
  vendor/bin/phpcs --config-set installed_paths vendor/drupal/coder/coder_sniffer
fi