#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

ipcalc -n "${AWS_VPC_CIDR}" | grep 'Address' | awk '{print $2}'

#
