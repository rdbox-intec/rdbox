#!/bin/sh

STATUS=0

if [ $# -ge 1 ] ; then
	VM_NAME_OPT=$1
fi

if [ -z "$VM_NAME_OPT" ] ; then
	echo "Usage: removeVM.sh VM-name"
	exit
fi

list_vm_name=$(VBoxManage list vms | cut -d ' ' -f 1 | sed -e 's/\"//g')

for vm_name in ${list_vm_name}; do
	if expr "$vm_name" : ".*<inaccessible>.*" > /dev/null; then
		continue
	elif [ "$vm_name" != "$VM_NAME_OPT" ] > /dev/null; then
		continue
	fi
	STATUS=1
done

if [ $STATUS = 0 ] ; then
	echo "$VM_NAME_OPT not found."
	exit
fi

VBoxManage controlvm "$VM_NAME_OPT" poweroff > /dev/null 2>&1
VBoxManage unregistervm "$VM_NAME_OPT" --delete
