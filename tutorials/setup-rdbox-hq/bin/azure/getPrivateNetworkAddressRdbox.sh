#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq
AZURE_RESOURCES_GROUP=$(az configure -l --query "[?contains(name,'group')].value"  --output json | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
AZURE_VNSUBNET_CIDR=$(az network vnet list -g "${AZURE_RESOURCES_GROUP}" --query "[].subnets[0].addressPrefix" | jq -r ".[]" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

ipcalc -n "${AZURE_VNSUBNET_CIDR}" | grep 'Address' | awk '{print $2}'

#
