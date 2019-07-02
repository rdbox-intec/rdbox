#!/bin/bash

NIC_VPN='vpn_rdbox'
while :
do
    N=`ip -4 addr show ${NIC_VPN} | wc -l`
    if [ "${N}" != "0" ] ; then
        break
    fi
    sleep 1
done

#
