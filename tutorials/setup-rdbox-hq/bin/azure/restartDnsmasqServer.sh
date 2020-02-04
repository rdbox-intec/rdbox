#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
SERVER_TYPE=${SERVER_TYPE_VPNSERVER}

#
ssh_port=`./getServerSshPort.sh ${SERVER_TYPE}`
SERVER_ADDRESS_BUILD=`./getServerAddressBuild.sh ${SERVER_TYPE}`

#
echo "[INFO] Restarting dnsmasq@${SERVER_ADDRESS_BUILD}"
ssh -i "${FILE_PRIVATE_KEY}" -p $ssh_port ${ANSIBLE_REMOTE_USER}@${SERVER_ADDRESS_BUILD} "sudo /etc/init.d/dnsmasq restart"

#
