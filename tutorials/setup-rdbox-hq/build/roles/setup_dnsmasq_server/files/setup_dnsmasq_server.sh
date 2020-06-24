#!/bin/bash

# shellcheck source=../../../../conf/bashrc.rdbox-hq.example
source /home/"${SUDO_USER}"/.bashrc.rdbox-hq

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
    DEFAULT_NameServer=$(awk '{if ($1 == "nameserver") {print $1 " " $2}}' ${FILE_RESOLV_CONF}.rdbox.bak)
else
    echo "[WARNING] Can not found ${FILE_RESOLV_CONF}.rdbox.bak, then use ${FILE_RESOLV_CONF}"
    DEFAULT_NameServer=$(awk '{if ($1 == "nameserver") {print $1 " " $2}}' ${FILE_RESOLV_CONF})
fi

#
KUBE_NETWORK_ADDRESS=$(ipcalc -n "${KUBE_POD_NETWORK_CIDR}" | grep 'Address' | awk '{print $2}')
LST_NET_DEV=$(netstat -nr | grep -v -e 'Destination' -e 'docker0' -e 'cni' -e "${KUBE_NETWORK_ADDRESS}" -e 'vpn_rdbox' | grep -e '0.0.0.0' -e "${priv_net_adrs}" | awk '{if ($8!="") {print $8}}' | sort | uniq)

#
IP_VPNSERVER_THREE=$(cut -d'.' -f3 <<<"${RDBOX_NET_ADRS_VPNSERVER}")
IP_RDBMASTER_THREE=$(cut -d'.' -f3 <<<"${RDBOX_NET_ADRS_RDBOX_MASTER}")
IP_RDBMASTER_FOUR=$(cut -d'.' -f4 <<<"${RDBOX_NET_ADRS_RDBOX_MASTER}")
NETWORK_PREFIX=$(ipcalc "${RDBOX_NET_ADRS_VPNSERVER}" "${RDBOX_NET_SUBNETMASK}" -b | grep Network: | cut -d"/" -f 2)

cat <<EoCONF > /etc/dnsmasq.conf
strict-order
resolv-file=/etc/resolv.dnsmasq.conf
local=/hq.rdbox.lan/
domain=hq.rdbox.lan
expand-hosts
interface=vpn_rdbox
dhcp-leasefile=/var/lib/dnsmasq.leases
dhcp-range=192.168.${IP_RDBMASTER_THREE}.4,192.168.${IP_RDBMASTER_THREE}.254,${RDBOX_NET_SUBNETMASK},12h
dhcp-host=${RDBOX_NET_NAME_KUBE_MASTER},${RDBOX_NET_ADRS_KUBE_MASTER},infinite
dhcp-host=${RDBOX_NET_NAME_RDBOX_MASTER},${RDBOX_NET_ADRS_RDBOX_MASTER},infinite
dhcp-option=option:domain-search,00.rdbox.lan,hq.rdbox.lan
dhcp-option=option:classless-static-route,192.168.${IP_RDBMASTER_FOUR}.0/24,${RDBOX_NET_ADRS_RDBOX_MASTER}
dhcp-option=option:dns-server,${RDBOX_NET_ADRS_VPNSERVER}
port=${RDBOX_NET_DNS_AUTHORITATIVE_PORT}
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

cat <<EOF > /etc/bind/named.conf.options
options {
        directory "/var/cache/bind";

        listen-on port 53 { 127.0.0.1; 192.168.${IP_VPNSERVER_THREE}.0/${NETWORK_PREFIX}; };
        listen-on-v6 { none; };

        forward only;
        forwarders  { ${RDBOX_NET_ADRS_VPNSERVER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };

        dnssec-validation no;
        auth-nxdomain no;
        version none;
};

zone "rdbox.lan" IN {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_RDBOX_MASTER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
zone "00.rdbox.lan" IN {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_RDBOX_MASTER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
zone "${IP_RDBMASTER_THREE}.168.192.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_RDBOX_MASTER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};

zone "hq.rdbox.lan" IN {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_VPNSERVER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
zone "0.168.192.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_VPNSERVER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
zone "1.168.192.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_VPNSERVER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
zone "2.168.192.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_VPNSERVER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
zone "3.168.192.in-addr.arpa" {
        type forward;
        forward only;
        forwarders { ${RDBOX_NET_ADRS_VPNSERVER} port ${RDBOX_NET_DNS_AUTHORITATIVE_PORT}; };
};
EOF

#
systemctl enable systemd-networkd
systemctl enable systemd-networkd-wait-online
systemctl enable rdbox-nameserver.service
systemctl enable rdbox-wait-vpnclient.service
systemctl enable bind9

#
systemctl restart systemd-networkd
systemctl restart systemd-networkd-wait-online
systemctl restart rdbox-nameserver.service
systemctl restart rdbox-wait-vpnclient.service
systemctl restart bind9

#
