#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
kubectl -n kube-system create -f /home/${SUDO_USER}/rdbox/tmp/kube-proxy-amd64.yml
kubectl -n kube-system create -f /home/${SUDO_USER}/rdbox/tmp/kube-proxy-arm.yml
kubectl -n kube-system create -f /home/${SUDO_USER}/rdbox/tmp/kube-proxy-arm64.yml
#
