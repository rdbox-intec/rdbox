#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# disable/stop systemd-resolved
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved

# Save '/etc/resolv.conf' before install 'dnsmasq' package.
FILE_RESOLV_CONF="/etc/resolv.conf"
if [ -e "${FILE_RESOLV_CONF}.rdbox.bak" ] ; then
    echo "[WARNING] Found ${FILE_RESOLV_CONF}.rdbox.bak, then keep older file."
else
    echo "[INFO] Create backup ${FILE_RESOLV_CONF}.rdbox.bak"
    cp -p ${FILE_RESOLV_CONF} ${FILE_RESOLV_CONF}.rdbox.bak
fi

# remove symlink and create real-file
rm ${FILE_RESOLV_CONF}
cp -p ${FILE_RESOLV_CONF}.rdbox.bak ${FILE_RESOLV_CONF}

#
