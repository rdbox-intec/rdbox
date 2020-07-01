#!/bin/bash

# shellcheck source=../../../../conf/bashrc.rdbox-hq.example
source /home/"${SUDO_USER}"/.bashrc.rdbox-hq

# IP address for vpnserver
FILE_CLOUD_INIT_RDBOX=/home/${SUDO_USER}/rdbox/tmp/50-cloud-init.kube_master.yaml
cat << EOS_RDBOX > "${FILE_CLOUD_INIT_RDBOX}"
network:
    version: 2
    ethernets:
        vpn_rdbox:
            mtu: 1280
            dhcp4: yes
EOS_RDBOX

FILE_NETPLAN_CLOUD_INIT=/etc/netplan/99-vpn.yaml
cp "${FILE_CLOUD_INIT_RDBOX}" "${FILE_NETPLAN_CLOUD_INIT}"