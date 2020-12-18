#!/bin/sh

STATUS=0

if [ $# -ge 1 ] ; then
	VM_NAME_OPT=$1
fi

if [ -z "$VM_NAME_OPT" ] ; then
	echo "Usage: getPublicIPs.sh VM-name"
	exit
fi

HOST_NIC=$(netstat -nr|awk '{ if ($1 == "0.0.0.0") {print $8}}')
if [ -z "$HOST_NIC" ]; then
  HOST_NIC=$(netstat -nr|awk '{ if ($1 == "default") {print $4}}' | head -n 1)
fi
HOST_NETWORK=$(netstat -nr| grep "$HOST_NIC" |awk '{ if ($2 == "0.0.0.0" && $3 != "255.255.255.255") {print $1}}')
if [ -z "$HOST_NETWORK" ]; then
  HOST_NETWORK=$(netstat -nr| grep "$HOST_NIC" | awk '{ if ($1 ~ "^192.168" || $1 ~ "^172.16" || $1 ~ "^10") {print $1}}' | grep "/" | grep -v "32" | cut -d"/" -f 1)
fi

list_vm_name=$(VBoxManage list vms | cut -d ' ' -f 1 | sed -e 's/\"//g')

for vm_name in ${list_vm_name}; do
	if expr "$vm_name" : ".*<inaccessible>.*" > /dev/null; then
		continue
	elif [ "$vm_name" != "$VM_NAME_OPT" ] > /dev/null; then
		continue
	fi
	VM_PORT=$(VBoxManage showvminfo "$VM_NAME_OPT"| grep -i 'nic 1' | grep 'host port'|sed -e 's/.*host port = //g'|sed -e 's/,.*$//g')

	ssh-keygen -R "[localhost]:$VM_PORT" > /dev/null 2>&1
	ssh -p "$VM_PORT" -l vagrant -oStrictHostKeyChecking=no localhost 'ls' > /dev/null 2>&1

	NIC=$(ssh -p "$VM_PORT" -l vagrant localhost "netstat -nr|grep -e '^$HOST_NETWORK'|awk '{print \$8}'"| head -n 1 2> /dev/null)
  if [ -z "$NIC" ]; then
    NIC=$(ssh -p "$VM_PORT" -l vagrant localhost "netstat -nr|grep -e '^$HOST_NETWORK'|awk '{print \$8}'"| head -n 1 2> /dev/null)
  fi
	NIC=$(echo "$NIC" | sed -e "s/[\r\n]\+//g")

	if [ -n "$NIC" ] ; then
		VM_IP=$(ssh -p "$VM_PORT" -l vagrant localhost "ifconfig $NIC|egrep -e '^\s+inet\s+'|awk '{print \$2}'" 2> /dev/null)
    if [ -z "$NIC" ]; then
      VM_IP=$(ssh -p "$VM_PORT" -l vagrant localhost "ifconfig $NIC|egrep -e '^\s+inet\s+'|awk '{print \$2}'" 2> /dev/null)
    fi
		VM_IP=$(echo "${VM_IP}"|sed -e "s/[\r\n]\+//g")
		echo "$VM_IP"
		STATUS=1
	else
		STATUS=2
	fi
done

if [ $STATUS = 0 ] ; then
	echo "$VM_NAME_OPT not found."
elif [ $STATUS = 2 ] ; then
	echo "$VM_NAME_OPT does not have a Public IP."
fi
