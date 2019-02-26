#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# IP address for vpnserver
cat << EOS_RDBOX > /etc/network/interfaces.d/50-rdbox-init.cfg
auto vpn_rdbox
iface vpn_rdbox inet static
address ${RDBOX_NET_ADRS_KUBE_MASTER}
netmask ${RDBOX_NET_SUBNETMASK}
EOS_RDBOX

#
