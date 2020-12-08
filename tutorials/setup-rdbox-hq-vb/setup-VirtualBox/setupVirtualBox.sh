#!/bin/sh

RDBOX_CONFIG=../conf/rdbox-hq-vb.params

#
#--- DO NOT MODIFY UNDER THIS LINE ---
#
# shellcheck source=../conf/rdbox-hq-vb.params
. $RDBOX_CONFIG

# shellcheck disable=SC2153
if [ -n "$HTTP_PROXY" ] ; then
	export http_proxy=$HTTP_PROXY
fi
# shellcheck disable=SC2153
if [ -n "$HTTPS_PROXY" ] ; then
	export https_proxy=$HTTPS_PROXY
fi

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib"
sudo apt-get update
sudo apt-get install virtualbox-"$VIRTUALBOX_INSTALL_VERSION"
vboxmanage -v
