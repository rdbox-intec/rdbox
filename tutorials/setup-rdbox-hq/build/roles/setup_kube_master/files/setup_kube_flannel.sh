#!/bin/bash

# shellcheck source=./../../../../conf/bashrc.rdbox-hq.example
source /home/"${SUDO_USER}"/.bashrc.rdbox-hq

kubectl apply                         -f /home/"${SUDO_USER}"/rdbox/tmp/flannel/rbac
kubectl apply --namespace kube-system -f /home/"${SUDO_USER}"/rdbox/tmp/flannel
