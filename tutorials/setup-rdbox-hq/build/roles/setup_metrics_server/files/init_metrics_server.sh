#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
if [ ! -e "${HOME}/git" ] ; then
    mkdir -p ${HOME}/git
fi
cd ${HOME}/git
git clone --depth 1 -b v0.3.1 https://github.com/kubernetes-incubator/metrics-server.git

#
cd metrics-server/deploy/1.8+
patch metrics-server-deployment.yaml < ${HOME}/rdbox/tmp/metrics-server-deployment.yaml.patch

#
