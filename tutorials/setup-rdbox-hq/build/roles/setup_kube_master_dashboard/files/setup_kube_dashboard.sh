#!/bin/bash

source /home/${SUDO_USER}/.bashrc.rdbox-hq

#
kubectl --kubeconfig /etc/kubernetes/admin.conf apply -f /home/${SUDO_USER}/rdbox/tmp/kubernetes-dashboard.yml

# delete 'kubernetes-dashboard-certs'
kubectl -n kubernetes-dashboard delete secret kubernetes-dashboard-certs

# create(set) 'kubernetes-dashboard-certs'
kubectl -n kubernetes-dashboard create secret generic kubernetes-dashboard-certs --from-file=/home/${SUDO_USER}/.kube/dashboard/certs/

# restart kubernetes-dashboard with new certs by delete pods
while :
do
    KUBE_DASHBOARD_NAME=`kubectl -n kubernetes-dashboard describe pods kubernetes-dashboard | grep -e '^Name:' | sed -e 's#\s##g' | cut -d':' -f 2`
    if [ "${KUBE_DASHBOARD_NAME}" != "" ] ; then
        break
    fi
    sleep 5
done

kubectl -n kube-system delete pods "${KUBE_DASHBOARD_NAME}"

#
