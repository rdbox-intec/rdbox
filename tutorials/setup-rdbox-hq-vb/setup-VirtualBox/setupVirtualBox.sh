#!/bin/sh

RDBOX_CONFIG=../conf/rdbox-hq-vb.params

#
#--- DO NOT MODIFY UNDER THIS LINE ---
#

. $RDBOX_CONFIG

if ! [ -z "$HTTP_PROXY" ] ; then
	export http_proxy=$HTTP_PROXY
fi

if ! [ -z "$HTTPS_PROXY" ] ; then
	export https_proxy=$HTTPS_PROXY
fi

echo 'deb https://download.virtualbox.org/virtualbox/debian xenial contrib' >> /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
apt-get update
apt-get install virtualbox-$VIRTUALBOX_INSTALL_VERSION
vboxmanage -v
