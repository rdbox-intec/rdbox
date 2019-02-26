#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

source check_build_rdbox_hq.sh

#
source setenv_build_softether.sh

#
echo "[INFO] START : " `date +%Y-%m-%dT%H:%M:%S`

#
pushd . > /dev/null
cd ../bin/${RDBOX_HQ_BUILD_PF}

    #
    if [ "${VPN_SERVER_ADDRESS}" = "" ] ; then
        VPN_SERVER_ADDRESS=`./getServerAddressPrivateVpnserver.sh`
    fi
    echo "[INFO] USE VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS}"

    #
    if [ "${KUBE_MASTER_ADDRESS}" = "" ] ; then
        KUBE_MASTER_ADDRESS=`bash ./getServerAddressPublic.sh "${SERVER_TYPE_KUBEMASTER}"`
    fi
    echo "[INFO] USE KUBE_MASTER_ADDRESS=${KUBE_MASTER_ADDRESS}"

    #
    KUBE_MASTER_ADDRESS_BUILD=`bash ./getServerAddressBuild.sh "${SERVER_TYPE_KUBEMASTER}"`

    #
    LIST_kube_node=`./getKubeNodeList.sh`

#
popd > /dev/null

#
SERVER_TYPE=${SERVER_TYPE_KUBENODE}

#
for kube_node in ${LIST_kube_node} ;
do
    #
    echo "[INFO] ${kube_node}"

    #
    pushd . > /dev/null
    cd ../bin/${RDBOX_HQ_BUILD_PF}
    SERVER_SSH_PORT=`./getServerSshPort.sh "${SERVER_TYPE}" "${kube_node}"`
    SERVER_ADDRESS=`./getServerAddressBuild.sh "${SERVER_TYPE}" "${kube_node}"`
    popd > /dev/null

    #
    FILE_inventory="inventory.${SERVER_TYPE}"
    echo "[${SERVER_TYPE}]" > ${FILE_inventory}
    echo "${SERVER_ADDRESS} ansible_connection=ssh ansible_ssh_port=${SERVER_SSH_PORT} ansible_ssh_user=${ANSIBLE_REMOTE_USER} ansible_ssh_private_key_file=${FILE_PRIVATE_KEY}" >> ${FILE_inventory}

    cat ${FILE_inventory}

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
done

#
echo "[INFO] DONE : " `date +%Y-%m-%dT%H:%M:%S`

#
