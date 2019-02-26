#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
if [ ! -e "${HOME}/.kube/dashboard/certs/" ] ; then
    mkdir -p ${HOME}/.kube/dashboard/certs/
    chmod -R 750 ${HOME}/.kube/
fi

#
NAME_CERT=${HOME}/.kube/dashboard/certs/dashboard
openssl req -x509 -nodes -days ${KUBE_DASHBOARD_CERT_DAYS} -newkey rsa:${KUBE_DASHBOARD_CERT_BITS} -keyout ${NAME_CERT}.key -out ${NAME_CERT}.crt << EoCERTS
${KUBE_DASHBOARD_CERT_COUNTRY}
${KUBE_DASHBOARD_CERT_STATE}
${KUBE_DASHBOARD_CERT_LOCALITY}
${KUBE_DASHBOARD_CERT_ORGANIZATION}
${KUBE_DASHBOARD_CERT_ORGANIZATION_UNIT}
${KUBE_DASHBOARD_CERT_COMMON_NAME}
${KUBE_DASHBOARD_CERT_EMAIL}
EoCERTS

#
