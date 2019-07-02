#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# Save '/etc/resolv.conf' before install 'dnsmasq' package.
FILE_RESOLV_CONF="/etc/resolv.conf"
FILE_RESOLV_CONF_SYSTEMD="/var/run/systemd/resolve/resolv.conf"
if [ -e "${FILE_RESOLV_CONF}.rdbox.bak" ] ; then
    echo "[INFO] Found ${FILE_RESOLV_CONF}.rdbox.bak, then keep older file."
elif [ -e "${FILE_RESOLV_CONF_SYSTEMD}" ] ; then
    echo "[INFO] Found ${FILE_RESOLV_CONF_SYSTEMD}"
    echo "[INFO] Create backup ${FILE_RESOLV_CONF}.rdbox.bak"
    cp -p ${FILE_RESOLV_CONF_SYSTEMD} ${FILE_RESOLV_CONF}.rdbox.bak
elif [ -e "${FILE_RESOLV_CONF}" ] ; then
    echo "[INFO] Found ${FILE_RESOLV_CONF}"
    echo "[INFO] Create backup ${FILE_RESOLV_CONF}.rdbox.bak"
    cp -p ${FILE_RESOLV_CONF} ${FILE_RESOLV_CONF}.rdbox.bak
else
    echo "[WARNING] NOT Found ${FILE_RESOLV_CONF}"
    echo "nameserver 8.8.8.8" > ${FILE_RESOLV_CONF}.rdbox.bak
fi

# disable/stop systemd-resolved
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved

# remove symlink and create real-file
rm ${FILE_RESOLV_CONF}
cp -p ${FILE_RESOLV_CONF}.rdbox.bak ${FILE_RESOLV_CONF}

#
