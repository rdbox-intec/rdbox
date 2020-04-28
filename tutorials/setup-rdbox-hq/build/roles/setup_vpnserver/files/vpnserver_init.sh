#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# initial setup for vpnserver
vpncmd localhost:${VPN_SERVER_PORT} -server << EOS_RDBOX
HubCreate ${VPN_HUB_NAME} /PASSWORD ${VPN_HUB_PASS}
Hub ${VPN_HUB_NAME}
UserCreate ${VPN_USER_NAME} /GROUP:${VPN_USER_GROUP} /REALNAME:${VPN_USER_REAL} /NOTE:${VPN_USER_NOTE}
UserPasswordSet ${VPN_USER_NAME} /PASSWORD:${VPN_USER_PASS}
EOS_RDBOX

#
