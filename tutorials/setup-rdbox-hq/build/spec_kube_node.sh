#!/bin/bash

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

source check_build_rdbox_hq.sh

#
echo "[INFO] START tests for Kubernetes Node. :  $(date +%Y-%m-%dT%H:%M:%S)"

#
pushd . > /dev/null
cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit

    #
    if [ "${VPN_SERVER_ADDRESS}" = "" ] ; then
        VPN_SERVER_ADDRESS=$(./getServerAddressPrivateVpnserver.sh)
    fi
    echo "[INFO] USE VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS}"

    #
    if [ "${KUBE_MASTER_ADDRESS}" = "" ] ; then
        KUBE_MASTER_ADDRESS=$(bash ./getServerAddressPublic.sh "${SERVER_TYPE_KUBEMASTER}")
    fi
    echo "[INFO] USE KUBE_MASTER_ADDRESS=${KUBE_MASTER_ADDRESS}"

    #
    KUBE_MASTER_ADDRESS_BUILD=$(bash ./getServerAddressBuild.sh "${SERVER_TYPE_KUBEMASTER}")
    export KUBE_MASTER_ADDRESS_BUILD

    #
    LIST_kube_node=$(./getKubeNodeList.sh)

#
popd > /dev/null || exit

#
SERVER_TYPE=${SERVER_TYPE_KUBENODE}

#
ret=0
for kube_node in ${LIST_kube_node} ;
do
    #
    echo "[INFO] ${kube_node}"

    #
    pushd . > /dev/null
    cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
    SERVER_SSH_PORT=$(./getServerSshPort.sh "${SERVER_TYPE}" "${kube_node}")
    SERVER_ADDRESS=$(./getServerAddressBuild.sh "${SERVER_TYPE}" "${kube_node}")
    popd > /dev/null || exit

    #
    FILE_inventory="inventory.${SERVER_TYPE}"
    echo "[${SERVER_TYPE}]" > "${FILE_inventory}"
    echo "${SERVER_ADDRESS} ansible_connection=ssh ansible_port=${SERVER_SSH_PORT} ansible_user=${ANSIBLE_REMOTE_USER} ansible_ssh_private_key_file=${FILE_PRIVATE_KEY}" >> "${FILE_inventory}"

    cat "${FILE_inventory}"

    #
    cat <<EoAnsiblespec > .ansiblespec
---
-
  playbook: ${SERVER_TYPE}.yml
  inventory: inventory.${SERVER_TYPE}
EoAnsiblespec

    #
    if [ "${SERVER_SSH_PORT}" != "22" ] ; then
        ssh-keygen -R "${SERVER_ADDRESS_BUILD}:${SERVER_SSH_PORT}"
    else
        ssh-keygen -R "${SERVER_ADDRESS_BUILD}"
    fi

    #
    rake all
    current_ret=$?
    if [ $ret = 0 ]; then
      ret=$current_ret
    fi
done

#
echo "[INFO] DONE tests for Kubernetes Node. :  $(date +%Y-%m-%dT%H:%M:%S)"

exit $ret