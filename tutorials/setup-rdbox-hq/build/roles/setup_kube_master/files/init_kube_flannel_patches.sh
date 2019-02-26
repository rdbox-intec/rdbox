#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
curl --silent --output ${HOME}/rdbox/tmp/kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml

#
cp ${HOME}/rdbox/tmp/kube-flannel.yml ${HOME}/rdbox/tmp/kube-flannel-rbac.yml
cp ${HOME}/rdbox/tmp/kube-flannel.yml ${HOME}/rdbox/tmp/flannel-config.yml
cp ${HOME}/rdbox/tmp/kube-flannel.yml ${HOME}/rdbox/tmp/kube-flannel-amd64-edge.yml
cp ${HOME}/rdbox/tmp/kube-flannel.yml ${HOME}/rdbox/tmp/kube-flannel-amd64-hq.yml
cp ${HOME}/rdbox/tmp/kube-flannel.yml ${HOME}/rdbox/tmp/kube-flannel-arm.yml
cp ${HOME}/rdbox/tmp/kube-flannel.yml ${HOME}/rdbox/tmp/kube-flannel-arm-master.yml
patch -f ${HOME}/rdbox/tmp/kube-flannel-rbac.yml       < ${HOME}/rdbox/tmp/kube-flannel-rbac.yml.patch
patch -f ${HOME}/rdbox/tmp/flannel-config.yml          < ${HOME}/rdbox/tmp/flannel-config.yml.patch
patch -f ${HOME}/rdbox/tmp/kube-flannel-amd64-edge.yml < ${HOME}/rdbox/tmp/kube-flannel-amd64-edge.yml.patch
patch -f ${HOME}/rdbox/tmp/kube-flannel-amd64-hq.yml   < ${HOME}/rdbox/tmp/kube-flannel-amd64-hq.yml.patch
patch -f ${HOME}/rdbox/tmp/kube-flannel-arm.yml        < ${HOME}/rdbox/tmp/kube-flannel-arm.yml.patch
patch -f ${HOME}/rdbox/tmp/kube-flannel-arm-master.yml < ${HOME}/rdbox/tmp/kube-flannel-arm-master.yml.patch

#
