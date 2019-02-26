#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
kubectl -n kube-system delete ds kube-flannel-arm-ds-master
kubectl -n kube-system delete ds kube-flannel-arm-ds
kubectl -n kube-system delete ds kube-flannel-amd64-ds-edge
kubectl -n kube-system delete ds kube-flannel-amd64-ds-hq
kubectl -n kube-system delete configmap kube-flannel-cfg
kubectl -n kube-system delete serviceaccount flannel
kubectl delete clusterroles flannel
kubectl delete clusterrolebinding flannel

#
kubectl create                         -f /home/${SUDO_USER}/rdbox/tmp/kube-flannel-rbac.yml
kubectl create --namespace kube-system -f /home/${SUDO_USER}/rdbox/tmp/flannel-config.yml
kubectl create --namespace kube-system -f /home/${SUDO_USER}/rdbox/tmp/kube-flannel-amd64-edge.yml
kubectl create --namespace kube-system -f /home/${SUDO_USER}/rdbox/tmp/kube-flannel-amd64-hq.yml
kubectl create --namespace kube-system -f /home/${SUDO_USER}/rdbox/tmp/kube-flannel-arm.yml
kubectl create --namespace kube-system -f /home/${SUDO_USER}/rdbox/tmp/kube-flannel-arm-master.yml

#
