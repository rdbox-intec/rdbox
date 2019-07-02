#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
kubeadm init --pod-network-cidr=${KUBE_POD_NETWORK_CIDR} --apiserver-advertise-address=${RDBOX_NET_ADRS_KUBE_MASTER} --kubernetes-version=${KUBERNETES_VERSION}

#
kubectl --kubeconfig /etc/kubernetes/admin.conf label node `hostname` node.rdbox.com/location=hq

# remove symlink and create real-file for ${SUDO_USER}
rm /home/${SUDO_USER}/.kube/config
cp /etc/kubernetes/admin.conf /home/${SUDO_USER}/.kube/config
chown ${SUDO_USER}:${SUDO_GID} /home/${SUDO_USER}/.kube/config

# remove symlink and create real-file for root
rm -r ${HOME}/.kube/config
cp /etc/kubernetes/admin.conf ${HOME}/.kube/config

#
