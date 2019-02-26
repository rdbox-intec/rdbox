#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
cd /home/${SUDO_USER}/git
cd metrics-server

#
kubectl create -f deploy/1.8+/

#
