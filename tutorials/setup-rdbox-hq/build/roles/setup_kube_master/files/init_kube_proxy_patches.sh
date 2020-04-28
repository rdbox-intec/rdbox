#!/bin/bash

source "${HOME}"/.bashrc.rdbox-hq

#
output=$(kubectl -n kube-system get ds kube-proxy -o yaml)
if [ $? -eq 0 ]; then
  echo "${output}" > "${HOME}"/rdbox/tmp/kube-proxy.yml.out
fi
bash "${HOME}"/rdbox/tmp/format_kube-proxy-yml.sh "${HOME}"/rdbox/tmp/kube-proxy.yml.out > "${HOME}"/rdbox/tmp/kube-proxy.yml.orig

#
bash "${HOME}"/rdbox/tmp/kube-proxy-amd64.yml.patch.sh > "${HOME}"/rdbox/tmp/kube-proxy-amd64.yml.patch
bash "${HOME}"/rdbox/tmp/kube-proxy-arm.yml.patch.sh   > "${HOME}"/rdbox/tmp/kube-proxy-arm.yml.patch
bash "${HOME}"/rdbox/tmp/kube-proxy-arm64.yml.patch.sh   > "${HOME}"/rdbox/tmp/kube-proxy-arm64.yml.patch

#
cp "${HOME}"/rdbox/tmp/kube-proxy.yml.orig "${HOME}"/rdbox/tmp/kube-proxy-amd64.yml
cp "${HOME}"/rdbox/tmp/kube-proxy.yml.orig "${HOME}"/rdbox/tmp/kube-proxy-arm.yml
cp "${HOME}"/rdbox/tmp/kube-proxy.yml.orig "${HOME}"/rdbox/tmp/kube-proxy-arm64.yml
patch -f "${HOME}"/rdbox/tmp/kube-proxy-amd64.yml < "${HOME}"/rdbox/tmp/kube-proxy-amd64.yml.patch
patch -f "${HOME}"/rdbox/tmp/kube-proxy-arm.yml   < "${HOME}"/rdbox/tmp/kube-proxy-arm.yml.patch
patch -f "${HOME}"/rdbox/tmp/kube-proxy-arm64.yml   < "${HOME}"/rdbox/tmp/kube-proxy-arm64.yml.patch

#
