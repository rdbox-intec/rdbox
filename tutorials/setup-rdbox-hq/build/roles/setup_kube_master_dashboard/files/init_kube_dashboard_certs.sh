#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

SERVER_ADDRESS_PUBLIC=${1}
RDBOX_HQ_BUILD_PF=${2}
SERVER_ADDRESS_VPN=$(ip -f inet -o addr show vpn_rdbox|cut -d\  -f 7 | cut -d/ -f 1 | tr -d '\n')
COMMON_NAME=$(wget -qO- http://ipecho.net/plain ; echo)

#
if [ ! -e "${HOME}/.kube/dashboard/certs/" ] ; then
    mkdir -p "${HOME}"/.kube/dashboard/certs/
    chmod -R 750 "${HOME}"/.kube/
fi

if [ "${RDBOX_HQ_BUILD_PF}" = "vb" ] ; then
    COMMON_NAME=${SERVER_ADDRESS_PUBLIC}
fi

echo "subjectAltName =  DNS:${COMMON_NAME}, DNS:${SERVER_ADDRESS_PUBLIC}, DNS:${SERVER_ADDRESS_VPN}, IP:${COMMON_NAME}, IP:${SERVER_ADDRESS_PUBLIC}, IP:${SERVER_ADDRESS_VPN}" > "${HOME}"/.kube/dashboard/certs/subjectnames.txt

#
NAME_CERT="${HOME}"/.kube/dashboard/certs/dashboard
openssl rand -out "${HOME}"/.rnd -hex 256
openssl genrsa 2048 > ${NAME_CERT}.key
openssl req -new -key ${NAME_CERT}.key -subj "/C=${KUBE_DASHBOARD_CERT_COUNTRY}/ST=${KUBE_DASHBOARD_CERT_STATE}/O=${KUBE_DASHBOARD_CERT_ORGANIZATION}/CN=${COMMON_NAME}" > ${NAME_CERT}.csr
openssl x509 -days 600 -req -extfile "${HOME}"/.kube/dashboard/certs/subjectnames.txt -signkey ${NAME_CERT}.key < ${NAME_CERT}.csr > ${NAME_CERT}.crt

#
