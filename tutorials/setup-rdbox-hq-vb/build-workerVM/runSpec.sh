#!/bin/sh

if [ $# -ge 1 ] ; then
	VM_NAME_OPT=$1
fi

if [ -z "$VM_NAME_OPT" ] ; then
	echo "Usage: runSpec.sh VM-name"
	exit
fi

vagrant provision $VM_NAME_OPT --provision-with serverspec
