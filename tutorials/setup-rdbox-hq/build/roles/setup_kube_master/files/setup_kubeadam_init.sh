#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
kubeadm init --pod-network-cidr=${KUBE_POD_NETWORK_CIDR} --apiserver-advertise-address=${RDBOX_NET_ADRS_KUBE_MASTER} --kubernetes-version=${KUBERNETES_VERSION}

#
kubectl --kubeconfig /etc/kubernetes/admin.conf label node `hostname` node.rdbox.com/location=hq

#
cp /etc/kubernetes/admin.conf /home/${SUDO_USER}/.kube/config
chown ${SUDO_USER}:${SUDO_GID} /home/${SUDO_USER}/.kube/config


cp -r /home/${SUDO_USER}/.kube ${HOME}/
#
