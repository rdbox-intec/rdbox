#!/bin/bash

# for DEBUG verbose message level
#VERBOSE=-vvv
#VERBOSE=-vvvv

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

source check_build_rdbox_hq.sh

#
echo "[INFO] START build for VPNServer. :  $(date +%Y-%m-%dT%H:%M:%S)"

#
pushd . > /dev/null
cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
SERVER_TYPE=${SERVER_TYPE_VPNSERVER}
SERVER_SSH_PORT=$(./getServerSshPort.sh "${SERVER_TYPE}")
SERVER_ADDRESS_BUILD=$(./getServerAddressBuild.sh "${SERVER_TYPE}")
SERVER_ADDRESS_PUBLIC=$(./getServerAddressPublic.sh "${SERVER_TYPE}")
VPN_SERVER_ADDRESS=$(./getServerAddressPrivateVpnserver.sh)
echo "[INFO] USE VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS}"
PRIVATE_NETWORK_ADDRESS=$(./getPrivateNetworkAddressRdbox.sh)
echo "[INFO] USE PRIVATE_NETWORK_ADDRESS=${PRIVATE_NETWORK_ADDRESS}"
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
OPTS_EXTRA_VARS="VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS} ansible_port=${SERVER_SSH_PORT} RDBOX_HQ_BUILD_PF=${RDBOX_HQ_BUILD_PF} PRIVATE_NETWORK_ADDRESS=${PRIVATE_NETWORK_ADDRESS} FILE_PRIVATE_KEY=${FILE_PRIVATE_KEY} FILE_PUBLIC_KEY=${FILE_PUBLIC_KEY} SUDO_USER=${ANSIBLE_REMOTE_USER}"
ansible-playbook ${VERBOSE:+""} --timeout 120 -i inventory."${SERVER_TYPE}" ${OPTS_BECOME_PASS:+""} -u "${ANSIBLE_REMOTE_USER}" --private-key="${FILE_PRIVATE_KEY}" --extra-vars "${OPTS_EXTRA_VARS}" "${SERVER_TYPE}".yml
STA_ANSIBLE=$?

#
if [ "${STA_ANSIBLE}" = "0" ] ; then
    #
    DIR_VPNSERVER_ADDRESS="${HOME}/rdbox/fetch/${SERVER_ADDRESS_BUILD}"
    if [ ! -e "${DIR_VPNSERVER_ADDRESS}" ] ; then
        mkdir -p "${DIR_VPNSERVER_ADDRESS}"
    fi
    FILE_VPNSERVER_ADDRESS="${DIR_VPNSERVER_ADDRESS}/vpnserver"
    echo ""
    echo "[INFO] VPNSERVER address ( file://${FILE_VPNSERVER_ADDRESS} )"
    echo "${SERVER_ADDRESS_PUBLIC}" | tee "${FILE_VPNSERVER_ADDRESS}"
fi

#
echo "[INFO] DONE build for VPNServer. :  $(date +%Y-%m-%dT%H:%M:%S)"

exit $STA_ANSIBLE