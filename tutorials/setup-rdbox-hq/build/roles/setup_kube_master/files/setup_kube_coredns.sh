#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
kubectl -n kube-system get configmap coredns -o yaml > /home/${SUDO_USER}/rdbox/tmp/coredns-configmap.orig
grep -v loop /home/${SUDO_USER}/rdbox/tmp/coredns-configmap.orig > /home/${SUDO_USER}/rdbox/tmp/coredns-configmap.yml
kubectl -n kube-system apply -f /home/${SUDO_USER}/rdbox/tmp/coredns-configmap.yml

#
