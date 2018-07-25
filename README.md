# centos7-dev-env
CentOS 7 development VM built via Vagrant for VMware Fusion and Virtualbox

The master branch has an all-in-one environment that is meant to provide a template for simpler builds.

Branches
* master - all-in-one environment


master currently includes: (Latest = current stable or current in repo)
* git 2.18.0
* automake - Latest
* zsh - Latest
* gcc/g++ - Latest
* docker - Latest CE)
* ansible - Latest
* terraform 0.11.7
* packer 1.2.5
* postgreSQL 9.6
* pgadmin4 v3.1 (via python)
* sublime text 3 (evaluation)
* atom - Latest
* emacs 26.1
* VScode - Latest
* AWS python modules - Latest
* Google Cloud Platform python modules - Latest
* Azure python modules - Latest
* postman - Latest
* firefox - Latest
* terminator -Latest
* gdb - Latest
* Perl 5.16.3
* Python 2.7.15
* Python Latest (3.6.5)
* npm v5.6.0
* node.js 8.11.3 (LTS)
* Open VM Tools - VMware Fusion-only
* Virtualbox Guest Utils - Virtualbox only


## Usage
1. Clone the repository and cd to the centos7-dev-env directory
2. `vagrant up --provider=vmware_fusion` OR `vagrant up --provider=virtualbox`

for CLI-only
1. `vagrant ssh`

for GUI
1. login at the VM's console in the hypervisor UI (user: vagrant, pass: vagrant)
2. `~/startgui.sh` OR `systemctl isolate graphical.target` 

To always boot into the GUI
1. `~/persistsgui.sh` OR
2. `systemctl set-default graphical.target`
3. `rm '/etc/systemd/system/default.target'`
4. `ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'`


## TODO
* Test the Virtualbox version


## Known Issues
* Sometimes VMware Fusion does not launch the new VM - ctrl+C the Vagrant up command and try it again
* copy/Paste is not working from Host to Fusion console

