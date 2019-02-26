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
SERVER_TYPE=${SERVER_TYPE_VPNSERVER}
SERVER_SSH_PORT=`./getServerSshPort.sh "${SERVER_TYPE}"`
SERVER_ADDRESS_BUILD=`./getServerAddressBuild.sh "${SERVER_TYPE}"`
SERVER_ADDRESS_PUBLIC=`./getServerAddressPublic.sh "${SERVER_TYPE}"`
popd > /dev/null

#
FILE_inventory="inventory.${SERVER_TYPE}"
echo "[${SERVER_TYPE}]" > ${FILE_inventory}
echo "${SERVER_ADDRESS_BUILD} ansible_connection=ssh ansible_ssh_port=${SERVER_SSH_PORT} ansible_ssh_user=${ANSIBLE_REMOTE_USER} ansible_ssh_private_key_file=${FILE_PRIVATE_KEY}" >> ${FILE_inventory}

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

#
echo "[INFO] DONE : " `date +%Y-%m-%dT%H:%M:%S`

#
