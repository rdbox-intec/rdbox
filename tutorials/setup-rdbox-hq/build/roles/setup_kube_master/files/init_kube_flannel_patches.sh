#!/bin/bash

# shellcheck source=./../../../../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

mkdir -p "${HOME}"/rdbox/tmp/flannel
python3 "${HOME}"/rdbox/tmp/init_kube_flannel_patches.py "${HOME}"/rdbox/tmp/flannel
