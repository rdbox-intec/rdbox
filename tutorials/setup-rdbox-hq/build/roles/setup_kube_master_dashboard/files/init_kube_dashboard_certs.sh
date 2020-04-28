#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
if [ ! -e "${HOME}/.kube/dashboard/certs/" ] ; then
    mkdir -p "${HOME}"/.kube/dashboard/certs/
    chmod -R 750 "${HOME}"/.kube/
fi

echo "subjectAltName =  DNS:$(wget -qO- http://ipecho.net/plain ; echo), IP:$(wget -qO- http://ipecho.net/plain ; echo)" > "${HOME}"/.kube/dashboard/certs/subjectnames.txt

#
NAME_CERT="${HOME}"/.kube/dashboard/certs/dashboard
openssl rand -out "${HOME}"/.rnd -hex 256
openssl genrsa 2048 > ${NAME_CERT}.key
openssl req -new -key ${NAME_CERT}.key -subj "/C=${KUBE_DASHBOARD_CERT_COUNTRY}/ST=${KUBE_DASHBOARD_CERT_STATE}/O=${KUBE_DASHBOARD_CERT_ORGANIZATION}/CN=$(wget -qO- http://ipecho.net/plain ; echo)" > ${NAME_CERT}.csr
openssl x509 -days 3650 -req -extfile "${HOME}"/.kube/dashboard/certs/subjectnames.txt -signkey ${NAME_CERT}.key < ${NAME_CERT}.csr > ${NAME_CERT}.crt

#
