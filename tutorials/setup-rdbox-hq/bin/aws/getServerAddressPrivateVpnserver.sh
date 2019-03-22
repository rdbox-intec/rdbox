#!/bin/bash

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

source ${HOME}/.bashrc.rdbox-hq
SERVER_TYPE=${SERVER_TYPE_VPNSERVER}

#
LIST_SERVER_NAME=`aws ec2 describe-instances --query "Reservations[*].Instances[*].Tags[*].Value" --filters "Name=tag:Name,Values=${RDBOX_HQ_PREF_NAME}Ec2Instance${SERVER_TYPE}*" "Name=instance-state-name,Values=running" | grep ${RDBOX_HQ_PREF_NAME} | sed -e 's#[ \"\,]##g'| sort | uniq | grep -i "${SERVER_TYPE}"`
if [ "${LIST_SERVER_NAME}" == "" ] ; then
    echo "[ERROR] Cannot found server '${SERVER_TYPE}'"
    exit 1
fi

#
for server_name in ${LIST_SERVER_NAME} ; do
#    echo "[INFO] ${server_name}"
    server_address=`aws ec2 describe-instances --query "Reservations[*].Instances[*].PrivateIpAddress" --filters "Name=tag:Name,Values=${server_name}"  | grep -e '[0-9]' | sed -e 's#[\"]##g'`
    if [ "${server_address}" != "" ] ; then
        echo ${server_address}
    fi

    # update host certs in ${HOME}/.ssh/known_hosts
#    ssh-keygen -R "${server_address}" > /dev/null
#    ssh -l "${ANSIBLE_REMOTE_USER}" -oStrictHostKeyChecking=no ${server_address} 'ls' > /dev/null

done

#
