#!/bin/bash

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

source ${HOME}/.bashrc.rdbox-hq
SERVER_TYPE=${SERVER_TYPE_VPNSERVER}
AZURE_RESOURCES_GROUP=$(az configure -l --query "[?contains(name,'group')].value"  --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

#
LIST_SERVER_NAME=$(az network nic list -g "${AZURE_RESOURCES_GROUP}" --query "[?contains(name, ${SERVER_TYPE})].ipConfigurations[].privateIpAddress" --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
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
