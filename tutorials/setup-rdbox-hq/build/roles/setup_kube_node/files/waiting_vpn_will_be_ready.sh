#!/bin/bash

#
INTERFACE="vpn_rdbox"
if [ "$1" != "" ] ; then
    INTERFACE=$1
fi

#
ifconfig "${INTERFACE}" > /dev/null 2>&1
STA_IFCONFIG=$?
if [ "${STA_IFCONFIG}" != "0" ] ; then
    echo "[ERROR] Unknown interface : ${INTERFACE}"
    exit ${STA_IFCONFIG}
fi

#
while :
do
    STAT_INTERFACE=`ifconfig "${INTERFACE}" | grep 'inet ' | sed -e 's#  *# #g'`
    if [ "${STAT_INTERFACE}" != "" ] ; then
        echo "[INFO] Found IPv4 address(VPN) : ${STAT_INTERFACE}"
        break
    fi

    echo "[INFO] Waiting VPN will be ready"
    sleep 5
done

#
