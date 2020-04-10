#!/bin/bash

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

source ${HOME}/.bashrc.rdbox-hq
SERVER_TYPE=$(echo "${SERVER_TYPE_VPNSERVER}" | tr '[:upper:]' '[:lower:]')

LIST_SERVER_NAME=$(gcloud compute instances list --filter "labels.server_type:'${SERVER_TYPE}'" --format json | jq -r ".[].networkInterfaces[].networkIP" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
if [ "${LIST_SERVER_NAME}" == "" ] ; then
    echo "[ERROR] Cannot found server '${SERVER_TYPE}'"
    exit 1
fi

#
for server_name in ${LIST_SERVER_NAME} ; do
    if [ "${server_name}" != "" ] ; then
        echo "${server_name}"
    fi
done

#
