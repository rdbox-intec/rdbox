#!/bin/bash

# for DEBUG verbose message level
#VERBOSE=-vvv
#VERBOSE=-vvvv

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

source check_build_rdbox_hq.sh

#
VPN_SERVER_ADDRESS=$1

#
echo "[INFO] START :  $(date +%Y-%m-%dT%H:%M:%S)"

#
pushd . > /dev/null
cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
SERVER_TYPE=${SERVER_TYPE_KUBEMASTER}
SERVER_SSH_PORT=$(./getServerSshPort.sh "${SERVER_TYPE}")
SERVER_ADDRESS_BUILD=$(./getServerAddressBuild.sh "${SERVER_TYPE}")
SERVER_ADDRESS_PUBLIC=$(./getServerAddressPublic.sh "${SERVER_TYPE}")
if [ "${VPN_SERVER_ADDRESS}" = "" ] ; then
    VPN_SERVER_ADDRESS=$(./getServerAddressPrivateVpnserver.sh)
    echo "[INFO] USE VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS}"
fi
popd > /dev/null || exit

#
echo "[${SERVER_TYPE}]" > inventory."${SERVER_TYPE}"
echo "${SERVER_ADDRESS_BUILD}" >> inventory."${SERVER_TYPE}"

#
if [ "${SERVER_SSH_PORT}" != "22" ] ; then
    if [ "${SERVER_ADDRESS_BUILD}" = "localhost" ] ; then
        ssh-keygen -R "[localhost]:${SERVER_SSH_PORT}" > /dev/null
    else
        ssh-keygen -R "${SERVER_ADDRESS_BUILD}:${SERVER_SSH_PORT}" > /dev/null
    fi
else
    ssh-keygen -R "${SERVER_ADDRESS_BUILD}" > /dev/null
fi

#
#OPTS_BECOME_PASS="--ask-become-pass"
export ANSIBLE_HOST_KEY_CHECKING=False
OPTS_EXTRA_VARS="SERVER_ADDRESS_PUBLIC=${SERVER_ADDRESS_PUBLIC} VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS} ansible_port=${SERVER_SSH_PORT} RDBOX_HQ_BUILD_PF=${RDBOX_HQ_BUILD_PF} FILE_PRIVATE_KEY=${FILE_PRIVATE_KEY} FILE_PUBLIC_KEY=${FILE_PUBLIC_KEY} SUDO_USER=${ANSIBLE_REMOTE_USER}"
ansible-playbook ${VERBOSE:+""} --timeout 120 -i inventory."${SERVER_TYPE}" ${OPTS_BECOME_PASS:+""} -u "${ANSIBLE_REMOTE_USER}" --private-key="${FILE_PRIVATE_KEY}" --extra-vars "${OPTS_EXTRA_VARS}" "${SERVER_TYPE}".yml
STA_ANSIBLE=$?

#
if [ "${STA_ANSIBLE}" = "0" ] ; then
    #
    DIR_KUBE_MASTER_ADDRESS="${HOME}/rdbox/fetch/${SERVER_ADDRESS_BUILD}"
    if [ ! -e "${DIR_KUBE_MASTER_ADDRESS}" ] ; then
        mkdir -p "${DIR_KUBE_MASTER_ADDRESS}"
    fi
    FILE_KUBE_MASTER_ADDRESS="${DIR_KUBE_MASTER_ADDRESS}/address"
    echo ""
    echo "[INFO] Kubernetes Master address ( file://${FILE_KUBE_MASTER_ADDRESS} )"
    echo "${SERVER_ADDRESS_PUBLIC}" | tee "${FILE_KUBE_MASTER_ADDRESS}"
fi

#
echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"