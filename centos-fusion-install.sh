#!/bin/bash
set -x
HOME="/home/vagrant"

# Versions
TERRAFORM_VERSION="0.11.7"
PACKER_VERSION="1.2.5"
PYTHON2_VERSION="2.7.15"
PYTHON3_VERSION="3.6.5"
GIT_VERSION="2.18.0"
EMACS_VERSION="26.1"
MINISHIFT_VERSION="1.21.0"
NVM_VERSION="0.33.11"
NODE_VERSION="8.11.3"
PGADMIN4_VERSION="3.1"
#ATOM_VERSION="1.18.0" # Latest

#pip locations
pip2=/usr/local/bin/pip2.7
pip3=/usr/bin/pip3.6

#python short version numbers
py2=${PYTHON2_VERSION%.*}
py3=${PYTHON3_VERSION%.*}


# create new ssh key
[[ ! -f $HOME/.ssh/mykey ]] \
&& mkdir -p $HOME/.ssh \
&& ssh-keygen -f $HOME/.ssh/mykey -N '' \
&& chown -R vagrant:vagrant $HOME/.ssh

#set MAKEFLAGS 
export MAKEFLAGS="-j$(expr $(nproc) \+ 1)"

# remove bad repo
sudo yum-config-manager --disable direct-centos7-gluster

# install epel repo
sudo yum install -y epel-release

#install development tools
sudo yum groupinstall -y "development tools"

#install additional devel libs
sudo yum install -y zlib-devel bzip2-devel ncurses-devel gnutls-devel sqlite-devel tk-devel gdbm-devel db4-devel libffi-devel libpcap-devel xz-devel expat-devel

#install main packages
sudo yum install -y automake autofs autoconf wget cairo cmake cpp dos2unix expect gcc gdb libxml2-devel nginx p7zip perl-XML-Dumper rng-tools. qemu-kvm libvirt kompose ansible python-devel python3-devel

#install X11
sudo yum groupinstall -y "X Window system"

#install MATE
sudo yum groupinstall -y "MATE Desktop"

#docker
curl -fsSL get.docker.com -o get-docker.sh && sudo chmod +x get-docker.sh && sudo ./get-docker.sh

# add vagrant to docker group
sudo usermod -aG docker vagrant
newgrp docker

#rpm-build packages and custom python
sudo yum install -y rpm-build readline-devel openssl-devel pam-devel perl-CPAN mariadb-devel zsh

# python2
wget -q http://python.org/ftp/python/${PYTHON2_VERSION}/Python-${PYTHON2_VERSION}.tar.xz
tar xf Python-${PYTHON2_VERSION}.tar.xz
cd Python-${PYTHON2_VERSION}
./configure --enable-optimizations #--prefix=/opt/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && sudo make altinstall
cd ~
sudo /usr/local/bin/python2.7 -m ensurepip

#python3
#remove old python bins
sudo rm /usr/local/bin/python3*
sudo rm /usr/local/bin/pip3*
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
sudo yum install -y python36u python36u-pip python36u-devel

#update git
sudo yum erase -y git
wget -q  https://mirrors.edge.kernel.org/pub/software/scm/git/git-${GIT_VERSION}.tar.xz
tar xf git-${GIT_VERSION}.tar.xz
cd git-${GIT_VERSION}
./configure
make && sudo make install
cd ~

# pip modules
sudo $pip2 install --upgrade pip 
sudo $pip2 install --upgrade virtualenv requests falcon flask cryptography gevent gunicorn httpie flask-sqlalchemy falcon-auth PyJWT PyJKS cassandra-driver psycopg2-binary flake8 pycrypto 
sudo $pip3 install --upgrade pip
sudo $pip3 install --upgrade virtualenv requests falcon flask cryptography gevent gunicorn httpie flask-sqlalchemy falcon-auth PyJWT PyJKS cassandra-driver psycopg2-binary flake8 pycrypto 
# asn1crypto Babel backports.ssl-match-hostname cassandra-driver certifi cffi chardet colorama configparser cryptography Cython docutils enum34 falcon falcon-auth filelock flake8 
# futures gevent greenlet gunicorn httpie idna ipaddress Jinja2 jmespath jsonpatch jsonpointer kitchen lockfile lxml MarkupSafe mccabe metaextract paramiko ply psutil psycopg2-binary py2pack pyasn1 
# pycodestyle pycparser pycrypto pyflakes Pygments PyJWT pystache python-dateutil python-mimeparse pytz requests scp six urllib3

# install cloud api modules for AWS, GCP and Azure
sudo $pip3 install --upgrade awscli
sudo $pip3 install --upgradeawsebcli
sudo $pip3 install --upgrade google-cloud
sudo $pip3 install --upgrade azure

sudo $pip2 install --upgrade awscli
sudo $pip2 install --upgrade awsebcli
sudo $pip2 install --upgrade google-cloud
sudo $pip2 install --upgrade azure

#instal X widgets for emacs
sudo yum install -y libXaw gtk2-devel libXpm-devel libjpeg-devel libgif-devel libungif-devel libtiff-devel
#install emacs 
wget -q http://ftp.gnu.org/gnu/emacs/emacs-${EMACS_VERSION}.tar.xz
tar xf emacs-${EMACS_VERSION}.tar.xz
cd emacs-${EMACS_VERSION}
./autogen.sh
./configure #–without-makeinfo –with-x-toolkit=yes –with-xpm=no –with-jpeg=no –with-png=no –with-gif=no –with-tiff=no
sudo make install

#install minishift
sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.7.0/docker-machine-driver-kvm -o /usr/local/bin/docker-machine-driver-kvm
sudo chmod +x /usr/local/bin/docker-machine-driver-kvm
sudo usermod -aG libvirt vagrant
newgrp libvirt

#installl minishift
wget -q https://github.com/minishift/minishift/releases/download/v${MINISHIFT_VERSION}/minishift-${MINISHIFT_VERSION}-linux-amd64.tgz \
&& tar zxf minishift-${MINISHIFT_VERSION}-linux-amd64.tgz \
&& sudo mv minishift-${MINISHIFT_VERSION}-linux-amd64/minishift /usr/local/bin/. \
&& sudo chmod +x /usr/local/bin/minishift \
&& rm -Rf ./minishift-${MINISHIFT_VERSION}-linux-amd64 \
&& rm -f ./minishift-${MINISHIFT_VERSION}-linux-amd64.tgz
cd ~

# postgresql 9.6 libs
wget -q https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sudo yum install -y pgdg-centos96-9.6-3.noarch.rpm
sudo yum update -y
sudo yum install -y postgresql96-libs postgresql96-devel postgresql96-plperl postgresql96-server postgresql96-plpython 
export PATH=/usr/lib/postgresql/9.6/bin/:$PATH
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl enable postgresql-9.6
sudo systemctl start postgresql-9.6
sudo systemctl stop postgresql-9.6

#postman
wget -q https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz \
&& tar -xzf postman.tar.gz -C /opt \
&& rm -f ./postman.tar.gz \
&& sudo ln -s /opt/Postman/Postman /usr/bin/postman \
&& sudo ln -s /opt/Postman/app/resources/app/assets/icon.png /usr/share/icons/postman.png

#install node.js
sudo wget -qO- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | bash \
&& export NVM_DIR="$HOME/.nvm" \
&& [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
nvm install ${NODE_VERSION}

# terraform
T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}
[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& sudo unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& sudo chmod +x /usr/local/bin/terraform \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(/usr/local/bin/packer -v)
P_RETVAL=$?
[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& sudo unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& sudo chmod +x /usr/local/bin/packer \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

# install vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo yum check-update
sudo yum install -y code

#install atom
sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'
sudo yum install -y atom

#install sublime text 3
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo yum install -y sublime-text 

#install chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum install -y ./google-chrome-stable_current_x86_64.rpm

# firefox and terminator
sudo yum install -y firefox terminator

#open-vm-tools (VMware - only)
sudo yum install -y open-vm-tools

#pgadmin4
wget -q  https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN4_VERSION}/pip/pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl
sudo $pip2 install ./pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl
sudo $pip3 install ./pgadmin4-${PGADMIN4_VERSION}-py2.py3-none-any.whl
sudo cp /usr/local/lib/python${py2}/site-packages/pgadmin4/pgadmin/static/favicon.ico /usr/share/icons/pgadmin4.icon
sudo mkdir /var/lib/pgadmin
sudo chmod -R 777 /var/lib/pgadmin
sudo mkdir /var/log/pgadmin
sudo chmod -R 777 /var/log/pgadmin

#oh my zsh
sudo wget -q https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

# create startgui.sh
startgui=$HOME/startgui.sh
cat <<STARTGUI >$startgui
#!/usr/bin/env sh

systemctl isolate graphical.target

STARTGUI
chmod +x $startgui

# create persistgui.sh
persistgui=$HOME/persistgui.sh
cat <<PERMGUI >$persistgui
#!/usr/bin/env sh

systemctl set-default graphical.target
rm '/etc/systemd/system/default.target'
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'

echo "Reboot to start in the GUI"
PERMGUI
chmod +x $persistgui

#setup GUI desktop launchers

#pgAdmin4
pgad_launch=/usr/local/bin/pgadmin4.sh
sudo touch $pgad_launch
sudo chmod 777 $pgad_launch
cat <<PG4LN >$pgad_launch
#!/usr/bin/env sh

/usr/local/bin/python${py2} /usr/local/lib/python${py2}/site-packages/pgadmin4/pgAdmin4.py

PG4LN


pgad4=/usr/share/applications/pgadmin4.desktop
sudo touch $pgad4
sudo cat <<PGAD4 >$pgad4  
[Desktop Entry]
Name=PGAdmin4
Terminal=false
Comment=Database Administration Tool.
GenericName=Database Administration Tool
Exec=mate-terminal -e "/usr/local/bin/pgadmin4.sh"
Icon=/usr/share/icons/pgadmin4.icon
Type=Application
StartupNotify=true
Categories=GNOME;GTK;Utility;Development;
MimeType=text/plain;
StartupWMClass=PGAdmin4

PGAD4

#postman
pman=/usr/share/applications/postman.desktop
sudo touch $pman
sudo chmod 777 $pman
cat <<PMAN >$pman  
[Desktop Entry]
Name=Postman
Comment=An API Test Suite.
GenericName=API Test Suite
Exec=/usr/bin/postman
Icon=/usr/share/icons/postman.png
Type=Application
StartupNotify=true
Categories=GNOME;GTK;Utility;Development;
MimeType=text/plain;
StartupWMClass=Postman

PMAN
# # clean up
# sudo yum clean packages -y

#make sure the vagrant user owns everything under the home directory
sudo chown -R vagrant:vagrant $HOME

# remove the annoying broken EULA prompt
sudo systemctl disable initial-setup-graphical.service

# reboot
sudo reboot
