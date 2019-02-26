#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# add user 'admin'
kubectl apply -f /home/${SUDO_USER}/rdbox/tmp/service-account.yml

#
