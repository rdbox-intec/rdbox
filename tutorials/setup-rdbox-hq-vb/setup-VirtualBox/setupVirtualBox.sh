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

add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib"
apt-get update
apt-get install virtualbox-$VIRTUALBOX_INSTALL_VERSION
vboxmanage -v
