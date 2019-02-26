#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

# get user info 'admin'
KUBE_ADMIN_SECRET=`kubectl -n kube-system get secret|grep admin| cut -f 1 -d ' '`
kubectl -n kube-system describe secret ${KUBE_ADMIN_SECRET} | tee /home/${SUDO_USER}/.kube/dashboard/admin.secret | grep 'token:' | sed -e 's#\s##g' | cut -f 2 -d ':' > /home/${SUDO_USER}/.kube/dashboard/admin.token

#
chown -R ${SUDO_UID}:${SUDO_GID} /home/${SUDO_USER}/.kube/dashboard/
chmod 400                        /home/${SUDO_USER}/.kube/dashboard/admin.*

#
