#!/bin/bash


source ${HOME}/.bashrc.rdbox-hq

#
SERVER_TYPE_VM=`./convServerType.sh ${SERVER_TYPE_KUBENODE}`

#
cd ../../../setup-rdbox-hq-vb
cd bin

#
list_worker=`bash ./getSshPorts.sh | grep "${SERVER_TYPE_VM}" | grep -v '#' | cut -d ' ' -f 1`

echo ${list_worker}

#
