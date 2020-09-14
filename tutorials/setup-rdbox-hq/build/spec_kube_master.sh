#!/bin/bash

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

source check_build_rdbox_hq.sh

#
echo "[INFO] START tests for Kubernetes Master.:  $(date +%Y-%m-%dT%H:%M:%S)"

#
pushd . > /dev/null
cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
SERVER_TYPE=${SERVER_TYPE_KUBEMASTER}
SERVER_SSH_PORT=$(./getServerSshPort.sh "${SERVER_TYPE}")
SERVER_ADDRESS_BUILD=$(./getServerAddressBuild.sh "${SERVER_TYPE}")
SERVER_ADDRESS_PUBLIC=$(./getServerAddressPublic.sh "${SERVER_TYPE}")
export SERVER_ADDRESS_PUBLIC
popd > /dev/null || exit

#
FILE_inventory="inventory.${SERVER_TYPE}"
echo "[${SERVER_TYPE}]" > "${FILE_inventory}"
echo "${SERVER_ADDRESS_BUILD} ansible_connection=ssh ansible_port=${SERVER_SSH_PORT} ansible_user=${ANSIBLE_REMOTE_USER} ansible_ssh_private_key_file=${FILE_PRIVATE_KEY}" >> "${FILE_inventory}"

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
ret=$?

#
echo "[INFO] DONE tests for Kubernetes Master. :  $(date +%Y-%m-%dT%H:%M:%S)"

exit $ret
