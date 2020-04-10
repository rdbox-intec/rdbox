#!/bin/bash


source ${HOME}/.bashrc.rdbox-hq

#
SERVER_TYPE=$(echo "${SERVER_TYPE_KUBENODE}" | tr '[:upper:]' '[:lower:]')
list_worker=$(gcloud compute instances list --filter "labels.server_type:${SERVER_TYPE}"  --format json | jq -r ".[].name" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

echo "${list_worker}"

#
