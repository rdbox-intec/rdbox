#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
FILE_DHCLIENT_CONF="/etc/dhcp/dhclient.conf"
if [ ! -e "${FILE_DHCLIENT_CONF}.orig" ] ; then
    cp -p "${FILE_DHCLIENT_CONF}" "${FILE_DHCLIENT_CONF}.orig"
fi
sed -i -e "s/domain-name, domain-name-servers, domain-search, host-name,/domain-name, domain-search, host-name,/" ${FILE_DHCLIENT_CONF}

# IP address for vpnserver
cat << EOS_RDBOX > /etc/network/interfaces.d/50-rdbox-init.cfg
auto vpn_rdbox
iface vpn_rdbox inet dhcp
EOS_RDBOX

#
