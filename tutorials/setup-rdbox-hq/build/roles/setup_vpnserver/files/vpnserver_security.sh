#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# initial setup for vpnserver
/usr/local/vpncmd/vpncmd localhost:${VPN_SERVER_PORT} -server << EOS_RDBOX
ListenerDisable 5555
ListenerDisable 1194
ListenerDisable 992
OpenVpnEnable no /PORTS:1194
EOS_RDBOX

#
