#!/bin/bash


source ${HOME}/.bashrc.rdbox-hq

#
SERVER_TYPE=${SERVER_TYPE_KUBENODE}
AZURE_RESOURCES_GROUP=$(az configure -l --query "[?contains(name,'group')].value"  --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
list_worker=$(az network public-ip list -g "${AZURE_RESOURCES_GROUP}" --query "[?contains(name,${SERVER_TYPE})].name" --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

echo "${list_worker}"

#
