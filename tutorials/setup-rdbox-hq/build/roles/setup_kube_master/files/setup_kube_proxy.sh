#!/bin/bash

# shellcheck source=./../../../../conf/bashrc.rdbox-hq.example
source /home/"${SUDO_USER}"/.bashrc.rdbox-hq

kubectl -n kube-system create -f /home/"${SUDO_USER}"/rdbox/tmp/kube-proxy-amd64.yaml
kubectl -n kube-system create -f /home/"${SUDO_USER}"/rdbox/tmp/kube-proxy-arm.yaml
kubectl -n kube-system create -f /home/"${SUDO_USER}"/rdbox/tmp/kube-proxy-arm64.yaml