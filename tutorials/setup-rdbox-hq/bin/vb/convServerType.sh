#!/bin/bash

SERVER_TYPE=$1
if [ "${SERVER_TYPE}" = "" ] ; then
    echo "Usage : $0 SERVER-TYPE"
    exit 1
fi

source ${HOME}/.bashrc.rdbox-hq

cd ../../../setup-rdbox-hq-vb
cd conf
source rdbox-hq-vb.params

if [ "${SERVER_TYPE}" = "${SERVER_TYPE_VPNSERVER}" ] ; then
  SERVER_TYPE_VM=${VPN_VMNAME}
elif [ "${SERVER_TYPE}" = "${SERVER_TYPE_KUBEMASTER}" ] ; then
  SERVER_TYPE_VM=${MASTER_VMNAME}
elif [ "${SERVER_TYPE}" = "${SERVER_TYPE_KUBENODE}" ] ; then
  SERVER_TYPE_VM=${WORKER_VMNAME_PREFIX}
else
  echo "[ERROR] Unknown SERVER_TYPE"
  exit 1
fi

#
echo ${SERVER_TYPE_VM}

#
