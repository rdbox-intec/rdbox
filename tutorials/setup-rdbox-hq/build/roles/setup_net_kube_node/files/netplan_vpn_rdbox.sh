#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
FILE_DHCLIENT_CONF="/etc/dhcp/dhclient.conf"
if [ ! -e "${FILE_DHCLIENT_CONF}.orig" ] ; then
    cp -p "${FILE_DHCLIENT_CONF}" "${FILE_DHCLIENT_CONF}.orig"
fi
sed -i -e "s/domain-name, domain-name-servers, domain-search, host-name,/domain-name, domain-search, host-name,/" ${FILE_DHCLIENT_CONF}

# IP address for vpnserver
FILE_CLOUD_INIT_RDBOX=/home/${SUDO_USER}/rdbox/tmp/50-cloud-init.kube_node.yaml
cat << EOS_RDBOX > ${FILE_CLOUD_INIT_RDBOX}
network:
    ethernets:
        vpn_rdbox:
            dhcp4: yes
            dhcp4-overrides:
                use-routes: false
    version: 2
EOS_RDBOX

# remove a entry(127.0.1.1) from /etc/hosts
grep    '127.0.1.1' /etc/hosts > /etc/hosts.removed-127.0.1.1
grep -v '127.0.1.1' /etc/hosts > /etc/hosts.$$
mv /etc/hosts.$$ /etc/hosts

#
FILE_NETPLAN_CLOUD_INIT=/etc/netplan/99-vpn.yaml
cp ${FILE_CLOUD_INIT_RDBOX} "${FILE_NETPLAN_CLOUD_INIT}"
#
