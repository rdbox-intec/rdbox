#!/bin/bash

# shellcheck source=./../../../../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

## Dump
if output=$(kubectl -n kube-system get ds kube-proxy -o yaml); then
  echo "${output}" > "${HOME}"/rdbox/tmp/kube-proxy.yml.out
fi

## data cleansing
bash "${HOME}"/rdbox/tmp/format_kube-proxy-yml.sh "${HOME}"/rdbox/tmp/kube-proxy.yml.out > "${HOME}"/rdbox/tmp/kube-proxy.yml.orig

## Specializing in RDBOX
python3 "${HOME}"/rdbox/tmp/init_kube_proxy_patches.py "${HOME}"/rdbox/tmp/kube-proxy.yml.orig "${HOME}"/rdbox/tmp
