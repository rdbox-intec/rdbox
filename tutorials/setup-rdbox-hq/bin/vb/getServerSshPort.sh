#!/bin/bash

SERVER_TYPE=$1
if [ "${SERVER_TYPE}" = "" ] ; then
    echo "Usage : $0 SERVER-TYPE [SERVER-NAME]"
    exit 1
fi
SERVER_NAME=$2

source ${HOME}/.bashrc.rdbox-hq

#
if [ "${SERVER_TYPE}" = "${SERVER_TYPE_KUBENODE}" ] ; then
    if [ "${SERVER_NAME}" = "" ] ; then
        echo "Usage : $0 SERVER-TYPE SERVER-NAME"
        echo "           ${SERVER_TYPE_KUBENODE} requires 'SERVER-NAME'"
        exit 1
    fi
    SERVER_TYPE_VM=${SERVER_NAME}
else
    SERVER_TYPE_VM=`./convServerType.sh ${SERVER_TYPE}`
fi

#
cd ../../../setup-rdbox-hq-vb
cd bin

#
ssh_port_local=`bash ./getSshPorts.sh | grep "${SERVER_TYPE_VM}" | grep -v '#' | cut -d ' ' -f 2`
if [ "${ssh_port_local}" = "" ] ; then
    echo "[ERROR] Cannot found server : SERVER-TYPE=${SERVER_TYPE}"
    exit 1
fi

#
echo ${ssh_port_local}

#
