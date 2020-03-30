#!/bin/bash

API_BASE='http://api.estagioemprogramacao.com'
INSTALL_DIR='/home/ubuntu/.ep'
SUPPORT_EMAIL='curso@estagioemprogramacao.com'

error() {
  echo -e "$1"
  echo "---"
  echo "Por favor, envie um email para $SUPPORT_EMAIL, informando o código" \
       "de erro apresentado."
}

##
# Check if all dependencies are installed.
# They should be, if the user selected the correct workspace type from C9
# and C9 hasn't changed anything.

check_dependency() {
  printf "Verificando '$1'... "
  if which $1 >/dev/null 2>&1 ; then
    printf "OK\n"
  else
    printf "'$1' não foi encontrado.\n"
    error "Não foi possível configurar o ambiente. Código de erro: ERR_DEPENDENCY_$1"
  fi
}

check_dependency 'git'
check_dependency 'ruby'
check_dependency 'mysql'

###
# PhantomJS installation
#

wget -O /tmp/phantomjs.tar.bz2 $API_BASE/downloads/phantomjs
tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp
sudo mkdir /opt/phantomjs
sudo mv /tmp/phantomjs-2.1.1-linux-x86_64 /opt/phantomjs/phantomjs-2.1.1-linux-x86_64
sudo ln -s /opt/phantomjs/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/bin/phantomjs

###
# CasperJS installation
#

sudo git clone https://github.com/n1k0/casperjs.git /opt/casperjs
sudo ln -s /opt/casperjs/bin/casperjs /usr/bin/casperjs

check_dependency 'phantomjs'
check_dependency 'casperjs'

##
# Create default directories
#

mkdir -p $INSTALL_DIR/log
mkdir -p $INSTALL_DIR/pids

##
# Add .bashrc modifications
#

cat >> /home/ubuntu/.bashrc <<EP_MODIFICATIONS
###############################################################################
# BEGIN EP MODIFICATIONS
###############################################################################

# Import EP-specific Bash utilities.
source $INSTALL_DIR/cli/install/bashrc

###############################################################################
# END EP MODIFICATIONS
###############################################################################
EP_MODIFICATIONS

source $INSTALL_DIR/cli/install/bashrc

##
# Install gems
#

gem install bundler
( cd $INSTALL_DIR/cli && bundle install )
