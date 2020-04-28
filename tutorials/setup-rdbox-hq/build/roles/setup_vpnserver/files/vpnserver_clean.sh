#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# initial setup for vpnserver
vpncmd localhost:${VPN_SERVER_PORT} -server << EOS_RDBOX
HubDelete DEFAULT
EOS_RDBOX

#
