# centos7-dev-env

CentOS 7 development VM built via Vagrant for VMware Fusion/Desktop or Virtualbox
Uses Ansible provisioner

The master branch has an all-in-one environment that is meant to provide a template for simpler builds.
Note: The VM's specs can be reduced in the Vagrantfile.  It will run reasonably well with 1 vCPU and 4G RAM.
      The current specs of 3 vCPUs and 8G RAM reduce the time required to provision.


Branches

* master - all-in-one environment

## Installation of Applications and Packages

Latest = current stable or current in repo

* ansible - Latest package
* git 2.21.0
* automake - Latest package
* zsh - Latest package
* gcc/g++ - Latest packages
* docker - Latest CE package
* ansible - Latest package
* terraform 0.11.13
* packer 1.4.0
* postgreSQL 11.2
* pgadmin4 v4.5 (via python)
* sublime text 3 - Latest package (evaluation version)
* atom - Latest
* emacs 26.1
* VScode - Latest package
* AWS python modules - Latest
* Google Cloud Platform python modules - Latest
* Azure python modules - Latest
* postman - Latest
* firefox - Latest package
* terminator -Latest package
* gdb - Latest package
* X11 and MATE Desktop - Latest packages
* Perl 5.16.3
* Python 2.7.16
* Python 3 Latest package (3.6.7)
* Slack 3.3.8 (Beta)
* npm v5.6.0
* node.js 8.11.3 (LTS)
* Open VM Tools - Latest package

For items with fixed versions, these are defined and can be changed for each Ansible role in the ./<role>/defaults/main.yml file.

## Application Configuration

Configuration variables are defined and can be changed for each Ansible role in the ./<role>/defaults/main.yml file.
To Enable/Disable configuration, set the configure_<app> boolean to true in centos7-dev-env/vars/main.yml
Configuration options available for:

* git
* postgreSQL


## Requirements

Ansible >=2.6 and Vagrant must be installed on the host system
vagrant-hostmanager plugin (free)

For VMware Fusion or Workstation
VMware Fusion >= v8.0 (Tested with v10.1.2)
vagrant-vmware-desktop plugin (Purchase at https://www.vagrantup.com/vmware/index.html)



## Usage

1. Clone the repository and cd to the centos7-dev-env directory
2. `vagrant plugin install vagrant-hostmanager`
3. Open ./centos7-dev-env/vars/main.yml. set items you wish to install to "true".  Set those you do not wish to install to "false" and save.
   Set the appropriate VM Guest install to true and the other to false

For VMware Fusion or Workstation

1. `vagrant plugin install vagrant-vmware-desktop`
2. `vagrant plugin license vagrant-vmware-desktop /path/to/license.lic`
3. `vagrant up --provider=vmware_fusion`

For VirtualBox

1. `vagrant plugin install vagrant-vbguest`
2. `vagrant up --provider=virtualbox --provision`
If necessary
3. `vagrant --provision`

Then
Go do something else for an hour or so


## Connecting

for CLI-only

1. `vagrant ssh`

for GUI

1. login at the VM's console in the VMware Fusion UI (user: vagrant, pass: vagrant)
2. `sudo ~/startgui.sh` OR `sudo systemctl isolate graphical.target`

To always boot into the GUI

1. `sudo ~/persistsgui.sh`
     OR
2. `sudo systemctl set-default graphical.target`
3. `sudo rm '/etc/systemd/system/default.target'`
4. `sudo ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'`


## Updating the VM

Not all roles support updating.  This is a work in progress!
Most packages that install via yum will be updated when update_packages is set to true
Some roles that do have support for updating are git, terraform, packer, and slack.
The only roles that have proper version checking and enforcement for the RPM version are Slack and PostgreSQL.
The other roles will be updated to match this over time.

1. Add Ansible Roles or modify versions
2. Set the install_<item> variable for each that was added/updated to true
3. run `vagrant provision`


## Recent updates

* updated python2 to 2.7.16
* updated packer to 1.4.0
* updated terraform to 0.11.13
* updated git to 2.21.0
* updated postgresql to 11.2
* updated postgresql repo to new "latest" repo
* set IP connections (127.0.0.1:5432) to "password" auth in pg_hba.conf template
* updated pgadmin to 4.5
* updated slack to 3.3.8 (still beta)
* added ansible playbook
* removed a old xen repo


## Older updates

* added default installed ver variable value to prevent a crash when no packages are installed for a given app
* added a mkdir call in the Vagrantfile to ensure /vagrant exists
* added configuration for git - sets parameters in the following sections
	* [core]
	* [color "branch"]
	* [color "status"]
	* [color]
	* [github]
	* [push]
	* [diff]
	* [user]
	* [difftool]
	* [merge]
* installs python2-pip for system python module installation
* added pip install of psycopg2 for Ansible postgres module
* added configuration for postgreSQL - sets/creates the following
	* postgresql.conf - sets listen to the public IP, sets max_connections to 300, scales mem and caching based on system RAM
	* pg_hba.conf - adds entry for IPv4 authentication by password for the public IP of the VM with /24 (CIDR)
	* creates role and grants superuser
	* creates a database
	* adds plperl and plythonu extensions to the database


## TODO

See CHANGELOG.md

## Known Issues

* Virtualbox provider will sometimes not begin provisioning after VM creation
  When this happens, it is necessary to run `vagrant --provision`
