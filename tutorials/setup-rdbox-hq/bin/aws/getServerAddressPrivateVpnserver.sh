#!/bin/bash

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

SERVER_TYPE=vpnserver

source ${HOME}/.bashrc.rdbox-hq

#
LIST_SERVER_NAME=`aws ec2 describe-instances --query "Reservations[*].Instances[*].Tags[*].Value" --filters "Name=tag-key,Values=Name" "Name=instance-state-name,Values=running" | grep RdboxhqEc2Instance | sed -e 's#[ \"\,]##g'| sort | uniq | grep -i "${SERVER_TYPE}"`
if [ "${LIST_SERVER_NAME}" == "" ] ; then
    echo "[ERROR] Cannot found server '${SERVER_TYPE}'"
    exit 1
fi

#
for server_name in ${LIST_SERVER_NAME} ; do
#    echo "[INFO] ${server_name}"
    server_address=`aws ec2 describe-instances --query "Reservations[*].Instances[*].PrivateIpAddress" --filters "Name=tag:Name,Values=${server_name}"  | grep -e '[0-9]' | sed -e 's#[\"]##g'`
    echo ${server_address}

    # update host certs in ${HOME}/.ssh/known_hosts
#    ssh-keygen -R "${server_address}" > /dev/null
#    ssh -l "${ANSIBLE_REMOTE_USER}" -oStrictHostKeyChecking=no ${server_address} 'ls' > /dev/null

done

#
