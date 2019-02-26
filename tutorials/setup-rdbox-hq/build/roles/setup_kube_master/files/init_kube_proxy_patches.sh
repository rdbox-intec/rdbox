#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
kubectl -n kube-system get ds kube-proxy -o yaml > ${HOME}/rdbox/tmp/kube-proxy.yml.out
bash ${HOME}/rdbox/tmp/format_kube-proxy-yml.sh ${HOME}/rdbox/tmp/kube-proxy.yml.out > ${HOME}/rdbox/tmp/kube-proxy.yml.orig

#
bash ${HOME}/rdbox/tmp/kube-proxy-amd64.yml.patch.sh > ${HOME}/rdbox/tmp/kube-proxy-amd64.yml.patch
bash ${HOME}/rdbox/tmp/kube-proxy-arm.yml.patch.sh   > ${HOME}/rdbox/tmp/kube-proxy-arm.yml.patch

#
cp ${HOME}/rdbox/tmp/kube-proxy.yml.orig ${HOME}/rdbox/tmp/kube-proxy-amd64.yml
cp ${HOME}/rdbox/tmp/kube-proxy.yml.orig ${HOME}/rdbox/tmp/kube-proxy-arm.yml
patch -f ${HOME}/rdbox/tmp/kube-proxy-amd64.yml < ${HOME}/rdbox/tmp/kube-proxy-amd64.yml.patch
patch -f ${HOME}/rdbox/tmp/kube-proxy-arm.yml   < ${HOME}/rdbox/tmp/kube-proxy-arm.yml.patch

#
