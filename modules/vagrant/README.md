# Vagrant module for Puppet

This module installs the latest version of Vagrant from http://www.vagrantup.com/downloads.html.

## Description

This module uses $::operatingsystem and $::architecture to determine what package to install.

NOTE: Versions older than 1.4.0 are not supported by this module because the download URL was complexer then.

Currently supports:

* CentOS and Redhat (i386 and x86)
* Ubuntu and Debian (i386 and x86)
* Windows (not tested)
* Darwin (not tested)

## Usage

Install latest version

    include vagrant

Install 1.5.0

    class { 'vagrant':
       version => '1.5.0'
    }

Install plugin

    vagrant::plugin { 'vagrant-hostmanager':
       user => 'myuser'
    }

Install plugin in specific version

    vagrant::plugin { 'vagrant-hostmanager':
       user    => 'myuser',
       version => 0.8.0
    }

The home directory of the user is generated with the prefix */home/* and the username.
This can be overridden with the *home* option.

    vagrant::plugin { 'vagrant-hostmanager':
       user => 'myuser',
       home => '/home/otheruser'
    }

There are some more options which are the same as supported by the *vagrant plugin* command.

- prerelease
- source
- entry_point

Install bash completion

    include vagrant::bash

Install sudo configuration

    include vagrant::sudo
