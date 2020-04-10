#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq
AZURE_VNSUBNET_CIDR=$(gcloud compute networks subnets list --filter "selfLink:$(gcloud compute instances list --format json | jq -r '.[0].networkInterfaces[0].subnetwork')"  --format json | jq -r ".[].ipCidrRange" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

ipcalc -n "${AZURE_VNSUBNET_CIDR}" | grep 'Address' | awk '{print $2}'

#
