#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
priv_net_adrs=$1
if [ "${priv_net_adrs}" = "" ] ; then 
    echo "[ERROR] Require private network address for kube-master"
    exit 1
fi

#
if [ -e "/etc/dnsmasq.conf" ] ; then
    mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
fi

#
echo "[INFO] Get nameserver(s)"
FILE_RESOLV_CONF="/etc/resolv.conf"
if [ -e "${FILE_RESOLV_CONF}.rdbox.bak" ] ; then 
    echo "[INFO] Found ${FILE_RESOLV_CONF}.rdbox.bak"
    DEFAULT_NameServer=`awk '{if ($1 == "nameserver") {print $1 " " $2}}' ${FILE_RESOLV_CONF}.rdbox.bak`
else
    echo "[WARNING] Can not found ${FILE_RESOLV_CONF}.rdbox.bak, then use ${FILE_RESOLV_CONF}"
    DEFAULT_NameServer=`awk '{if ($1 == "nameserver") {print $1 " " $2}}' ${FILE_RESOLV_CONF}`
fi

#
KUBE_NETWORK_ADDRESS=`ipcalc -n "${KUBE_POD_NETWORK_CIDR}" | grep 'Address' | awk '{print $2}'`
LST_NET_DEV=`netstat -nr | grep -v -e 'Destination' -e 'docker0' -e 'cni' -e "${KUBE_NETWORK_ADDRESS}" -e 'vpn_rdbox' | grep -e '0.0.0.0' -e '${priv_net_adrs}' | awk '{if ($8!="") {print $8}}' | sort | uniq`

#
cat <<EoCONF > /etc/dnsmasq.conf
#domain-needed
#bogus-priv
strict-order
resolv-file=/etc/resolv.dnsmasq.conf
server=//192.168.179.1
server=/rdbox.lan/192.168.179.1
server=/179.168.192.in-addr.arpa/192.168.179.1
local=/rdbox.lan/
domain=rdbox.lan
expand-hosts
interface=vpn_rdbox
no-dhcp-interface=vpn_rdbox
EoCONF

for net_dev in ${LST_NET_DEV} ; do
  cat <<EoCONF >> /etc/dnsmasq.conf
interface=${net_dev}
no-dhcp-interface=${net_dev}
EoCONF
done

#
cat <<EOF > /etc/resolv.dnsmasq.conf
${DEFAULT_NameServer}
nameserver 8.8.8.8
EOF

#
systemctl enable dnsmasq.service
systemctl restart dnsmasq.service

#
cat <<EOF > /etc/systemd/system/rdbox-nameserver.service
[Unit]
Description=modify current network
After=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/sh /usr/local/bin/rdbox-nameserver.sh
RemainAfterExit=yes

[Install]
WantedBy=network-online.target
EOF

#
cat <<EOF > /etc/systemd/system/rdbox-wait-vpnclient.service
[Unit]
Description = Wait network interface named 'vpn_rdbox'
Wants = multi-user.target
After=network.target
Before = dnsmasq.service

[Service]
Type = oneshot
ExecStart = /usr/local/bin/rdbox-wait-vpnclient.sh
Restart = no

[Install]
WantedBy = multi-user.target
EOF

#
systemctl enable systemd-networkd
systemctl enable systemd-networkd-wait-online
systemctl enable rdbox-nameserver.service
systemctl enable rdbox-wait-vpnclient.service

#
systemctl restart systemd-networkd
systemctl restart systemd-networkd-wait-online
systemctl restart rdbox-nameserver.service
systemctl restart rdbox-wait-vpnclient.service

#
