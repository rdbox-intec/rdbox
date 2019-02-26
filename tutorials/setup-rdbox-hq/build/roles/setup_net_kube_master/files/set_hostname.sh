#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# update hostnmae
echo ${RDBOX_NET_NAME_KUBE_MASTER} > /etc/hostname
hostname -F /etc/hostname

# update /etc/hosts
echo ${RDBOX_NET_ADRS_KUBE_MASTER} ${RDBOX_NET_NAME_KUBE_MASTER} >> /etc/hosts

#
