#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

SERVER_TYPE=$(echo "${1}" | tr '[:upper:]' '[:lower:]')
if [ "${SERVER_TYPE}" == "" ] ; then
    echo "Usage : $0 SERVER-TYPE [instancd-id]"
    exit 1
fi

LIST_InstanceId=$2
if [ "$2" = "" ] ; then
    LIST_InstanceId=$(gcloud compute instances list --filter "labels.server_type:${SERVER_TYPE}"  --format json | jq -r ".[].name" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
    if [ "${LIST_InstanceId}" == "" ] ; then
        echo "[ERROR] Cannot found server '${SERVER_TYPE}'"
        exit 1
    fi
fi

#
for server_name in ${LIST_InstanceId} ; do
    zone=$(gcloud compute instances list --filter "name:${server_name}"  --format json | jq -r ".[].labels.zone" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
    if [ "${zone}" != "" ] ; then
      server_address=$(gcloud compute instances describe "${server_name}" --zone "${zone}" --format json | jq -r ".networkInterfaces[].accessConfigs[].natIP" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')
      if [ "${server_address}" != "" ] ; then
          echo "${server_address}"
      fi
    fi
done

#
