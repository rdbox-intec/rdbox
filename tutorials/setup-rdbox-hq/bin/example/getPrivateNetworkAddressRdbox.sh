#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
cd ../../../setup-rdbox-hq-vb
cd conf

source rdbox-hq-vb.params
ipcalc -n "${PRIVATE_NETWORK}" | grep 'Address' | awk '{print $2}'

#
