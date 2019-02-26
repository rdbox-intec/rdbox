#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

SERVER_TYPE=$1
if [ "${SERVER_TYPE}" = "" ] ; then
    echo "Usage : $0 SERVER-TYPE [instancd-id]"
    exit 1
fi

#
SERVER_TYPE_VM=`./convServerType.sh ${SERVER_TYPE}`

#
cd ../../../setup-rdbox-hq-vb
cd bin

#
server_name=$2
if [ "${server_name}" = "" ] ; then
    server_name=`bash ./getSshPorts.sh | grep "${SERVER_TYPE_VM}" | grep -v '#' | cut -d ' ' -f 1`
    if [ "${server_name}" = "" ] ; then
        echo "[ERROR] Cannot found server name : SERVER-TYPE=${SERVER_TYPE}"
        exit 1
    fi
fi

#
server_address=`bash ./getPublicIP.sh "${server_name}"`
if [ "${server_address}" = "" ] ; then
    echo "[ERROR] Cannot found server address : SERVER-TYPE=${SERVER_TYPE}"
    exit 1
fi

#
echo ${server_address}

#
