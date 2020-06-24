#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
ADDRESS_DNSMASQ=$1

#
cat <<EOF > /usr/local/bin/rdbox-nameserver.sh
/sbin/dhclient vpn_rdbox
EOF
chmod +x /usr/local/bin/rdbox-nameserver.sh
/usr/local/bin/rdbox-nameserver.sh

#
cat <<EOF > /lib/systemd/system/rdbox-nameserver.service
[Unit]
Description=modify current network
After=softether-vpnclient.service

[Service]
Type=oneshot
ExecStart=/bin/bash /usr/local/bin/rdbox-nameserver.sh
RemainAfterExit=yes

[Install]
WantedBy=network-online.target
EOF

#
systemctl enable systemd-networkd
systemctl enable systemd-networkd-wait-online
systemctl enable rdbox-nameserver.service

#
systemctl restart systemd-networkd
systemctl restart systemd-networkd-wait-online
systemctl restart rdbox-nameserver.service

#
