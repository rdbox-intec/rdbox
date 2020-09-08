#!/bin/bash

set -x

project=$1
deployment=$2
count=0
success=0

export RDBOX_GCP_PROJECT="${project}"
export RDBOX_GCP_DEPLOYMENT="${deployment}"
export ANSIBLE_HOST_KEY_CHECKING=False 

gcloud config set project "${project}"
gcloud compute project-info add-metadata \
    --metadata enable-oslogin=TRUE \
    --project "${project}"
gcloud projects add-iam-policy-binding "${project}" \
    --member user:"$(gcloud auth list --format=json | jq -r .[0].account)" \
    --role roles/compute.osAdminLogin
gcloud compute os-login ssh-keys add \
    --key-file "${HOME}"/.ssh/authorized_keys \
    --ttl 0 \
    --project "${project}"

#####################################################
# Wait for Ansible to run until the communication is stable.
#####################################################
testip="$(python3 "$(dirname "$0")"/../ansible/inventory.py  | jq -r '.VpnBridge.hosts[0]')"
while :
do
  count=$((count + 1))
  if ping -w 1 -n -c 1 "${testip}" >> /dev/null; then
    echo "$(date +%H:%M:%S:%N) +++ OK +++"
    success=$((success + 1))
    if [ "$success" -eq 10 ]; then
      ansible-playbook \
          -i "$(dirname "$0")"/../ansible/inventory.py \
          -u "$(gcloud compute os-login describe-profile --format=json | jq -r '.posixAccounts[0].username')" \
          --private-key "${HOME}"/.ssh/id_rsa \
          --timeout 120 \
          -e FILE_PRIVATE_KEY="${HOME}"/.ssh/id_rsa \
          -e FILE_PUBLIC_KEY="${HOME}"/.ssh/authorized_keys \
          "$(dirname "$0")"/../ansible/main.yaml
      exit 0
    fi
    sleep 1
  else
    echo "$(date +%H:%M:%S:%N) +++ NG +++"
    success=0
    sleep 1
  fi
  if [ $count -eq 600 ]; then
    echo "$(date +%H:%M:%S:%N) +++ COUNT OVER +++"
    exit 2
  fi
done
