#!/bin/sh

RDBOX_CONFIG=../conf/rdbox-hq-vb.params

#
#--- DO NOT MODIFY UNDER THIS LINE ---
#

. $RDBOX_CONFIG

OPT_V=-v
HELP=-h

if [ $# -ge 1 ] && [ $1 = $HELP ] ; then
	echo "Usage: getSshPorts.sh [-v|-h]"
	echo "         -v vagrant form of VM-name"
	echo "         -h print this message"
	exit
fi

if [ $# -ge 1 ] && [ $1 = $OPT_V ] ; then
	VAGRANT_FORM=1
else
	VAGRANT_FORM=0
fi

list_vm_name=`VBoxManage list vms | cut -d ' ' -f 1 | sed -e 's/\"//g'`

for vm_name in ${list_vm_name}; do
	if expr "$vm_name" : ".*<inaccessible>.*" > /dev/null; then
		continue
	elif expr "$vm_name" : ".*$MASTER_VMNAME.*" > /dev/null ; then
		VM_NAME=$MASTER_VMNAME
	elif expr "$vm_name" : ".*$VPN_VMNAME.*" > /dev/null ; then
		VM_NAME=$VPN_VMNAME
	elif WORKER_VMNAME=`expr "$vm_name" : ".*\($WORKER_VMNAME_PREFIX-[0-9]*\)_.*"` ; then
		VM_NAME=$WORKER_VMNAME
	else
		continue
	fi

	VM_PORT=`VBoxManage showvminfo ${vm_name}| grep -i 'nic 1' | grep 'host port'|sed -e 's/.*host port = //g'|sed -e 's/,.*$//g'`

	if [ $VAGRANT_FORM -eq 1 ] ; then
		echo "$VM_NAME $VM_PORT"
	else
		echo "$vm_name $VM_PORT"
	fi
done
