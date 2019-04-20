# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- vscode extentions.
- continue playbook installs where applicable.
- Update roles for proper RPM version checking and enforcement.
- Add configuration for other apps such as NGINX.
- move the remote_tmp directory so it is available when switcing to other users such as postgres.

## [1.2.2] - 2019-04-20

### Changed

- python2 to 2.7.16
- packer to 1.4.0
- terraform to 0.11.13
- git to 2.21.0
- postgresql to 11.2
- postgresql repo to new "latest" repo
- set IP connections (127.0.0.1:5432) to "password" auth in pg_hba.conf template
- pgadmin to 4.5
- slack to 3.3.8 (still beta)
- changed all pip and yum with_items loops to new Ansible syntax to eliminate deprecation warnings



## [1.2.0] - 2019-04-20

### Added

- Ansible Playbook to install Ansible on VM.
- Changelog.

### Changed

- Updated centos7-dev-env variables.
- Updated centos7-dev-env tasks.
- Updated Bad Repos list.
- Updated Syntax where applicable.
- Updated README.

## [1.1.0] - 2018-08-25

### Added

- default installed ver variable value to prevent a crash when no packages are installed for a given app
- a mkdir call in the Vagrantfile to ensure /vagrant exists
- configuration for git - sets parameters in the following sections
	- [core]
	- [color "branch"]
	- [color "status"]
	- [color]
	- [github]
	- [push]
	- [diff]
	- [user]
	- [difftool]
	- [merge]
- installs python2-pip for system python module installation
- pip install of psycopg2 for Ansible postgres module
- configuration for postgreSQL - sets/creates the following
	- postgresql.conf - sets listen to the public IP, sets max_connections to 300, scales mem and caching based on system RAM
	- pg_hba.conf - adds entry for IPv4 authentication by password for the public IP of the VM with /24 (CIDR)
	- creates role and grants superuser
	- creates a database
	- adds plperl and plythonu extensions to the database


## [1.0.0] - 2018-08-23

### Added

- Everything
