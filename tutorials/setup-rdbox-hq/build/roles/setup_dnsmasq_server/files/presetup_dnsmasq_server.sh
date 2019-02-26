#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# Save '/etc/resolv.conf' before install 'dnsmasq' package.
FILE_RESOLV_CONF="/etc/resolv.conf"
if [ -e "${FILE_RESOLV_CONF}.rdbox.bak" ] ; then 
    echo "[WARNING] Found ${FILE_RESOLV_CONF}.rdbox.bak, then keep older file."
else
    echo "[INFO] Create backup ${FILE_RESOLV_CONF}.rdbox.bak"
    cp -p ${FILE_RESOLV_CONF} ${FILE_RESOLV_CONF}.rdbox.bak
fi

#
