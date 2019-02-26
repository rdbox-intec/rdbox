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

VAGRANT_DISKSIZE=`vagrant plugin list|grep vagrant-disksize|awk '{if ($1 == "vagrant-disksize") {print "1"}}'`
if [ -z "$VAGRANT_DISKSIZE" ]; then
	echo "vagrant-disksize plugin is not installed, so installing it..."
	vagrant plugin install vagrant-disksize
	echo "done."
fi

VAGRANT_VBGUEST=`vagrant plugin list|grep vagrant-vbguest|awk '{if ($1 == "vagrant-vbguest") {print "1"}}'`
if [ -z "$VAGRANT_VBGUEST" ]; then
	echo "vagrant-vbguest plugin is not installed, so installing it..."
	vagrant plugin install vagrant-vbguest
	echo "done."
fi

VAGRANT_PROXYCONF=`vagrant plugin list|grep vagrant-proxyconf|awk '{if ($1 == "vagrant-proxyconf") {print "1"}}'`
if [ -z "$VAGRANT_PROXYCONF" ]; then
	echo "vagrant-proxyconf plugin is not installed, so installing it..."
	vagrant plugin install vagrant-proxyconf
	echo "done."
fi

ID_PUB=$HOME/.ssh/id_rsa.pub

if [ -f $ID_PUB ]; then
	cp -pf $ID_PUB .
else
	echo "$ID_PUB not found and stopped."
	exit 0
fi

if [ -z "$RDBOX_USER_ACCOUNT" ] ; then
	echo "rdbox user account not specified and stopped."
	exit 0
fi

if [ -z "$RDBOX_USER_KEY" ] ; then
	echo "private key used for rdbox user is not specified and stopped."
	exit 0
fi

if [ -f $RDBOX_USER_KEY ]; then
	cp -pf $RDBOX_USER_KEY id_rsa
else
	echo "$RDBOX_USER_KEY not found and stopped."
	exit 0
fi

vagrant up

if [ -f id_rsa.pub ]; then
	rm -f id_rsa.pub
fi

if [ -f id_rsa ]; then
	rm -f id_rsa
fi
