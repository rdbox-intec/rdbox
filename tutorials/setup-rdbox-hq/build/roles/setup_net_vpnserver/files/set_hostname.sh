#!/bin/bash

# shellcheck source=../../../../conf/bashrc.rdbox-hq.example
source /home/"${SUDO_USER}"/.bashrc.rdbox-hq

# update hostnmae
echo "${RDBOX_NET_NAME_VPNSERVER}" > /etc/hostname
hostname -F /etc/hostname

# update /etc/hosts
echo "${RDBOX_NET_ADRS_VPNSERVER}" "${RDBOX_NET_NAME_VPNSERVER}" >> /etc/hosts

#
