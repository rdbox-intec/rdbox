#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq
AZURE_RESOURCES_GROUP=$(az configure -l --query "[?contains(name,'group')].value"  --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

SERVER_TYPE=$1
if [ "${SERVER_TYPE}" == "" ] ; then
    echo "Usage : $0 SERVER-TYPE [instancd-id]"
    exit 1
fi

LIST_InstanceId=$2
if [ "$2" = "" ] ; then
    LIST_InstanceId=$(az network public-ip list -g "${AZURE_RESOURCES_GROUP}" --query "[?contains(name,'${SERVER_TYPE}')].ipAddress" --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
    if [ "${LIST_InstanceId}" == "" ] ; then
        echo "[ERROR] Cannot found server '${SERVER_TYPE}'"
        exit 1
    else
        echo "${LIST_InstanceId}"
        exit 0
    fi
fi

#
for server_name in ${LIST_InstanceId} ; do
    server_address=$(az network public-ip list -g "${AZURE_RESOURCES_GROUP}" --query "[?contains(name,'${server_name}')].ipAddress" --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
    if [ "${server_address}" != "" ] ; then
        echo "${server_address}"
    fi
done

#
