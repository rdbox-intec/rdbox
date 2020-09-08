#!/bin/bash

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

#
SSH_USER=${ANSIBLE_REMOTE_USER}
if [ "$2" != "" ] ; then
    SSH_USER=$2
fi

#
if [ "$1" != "" ] ; then
    export ADRS_KUBE_MASTER=$1
else
    pushd . > /dev/null
    cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
    SERVER_TYPE=${SERVER_TYPE_KUBEMASTER}
    SERVER_ADDRESS_PUBLIC=$(./getServerAddressPublic.sh "${SERVER_TYPE}")

    # update host certs in ${HOME}/.ssh/known_hosts
    ssh-keygen  -R "${SERVER_ADDRESS_PUBLIC}" > /dev/null
    ssh -i "${FILE_PRIVATE_KEY}" -l "${SSH_USER}" -oStrictHostKeyChecking=no "${SERVER_ADDRESS_PUBLIC}" 'ls' > /dev/null
    popd > /dev/null || exit
fi

#
CMD_kubectl='sudo kubectl top node'
CMD="ssh -t -i ${FILE_PRIVATE_KEY} -l ${SSH_USER} ${SERVER_ADDRESS_PUBLIC} $CMD_kubectl"
echo "[INFO] Exec : ${CMD}"
${CMD}
