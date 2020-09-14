#!/bin/bash

# shellcheck source=./../../../../conf/bashrc.rdbox-hq.example
source /home/"${SUDO_USER}"/.bashrc.rdbox-hq

kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete ds kube-proxy-amd64
kubectl -n kube-system delete ds kube-proxy-arm
kubectl -n kube-system delete ds kube-proxy-arm64