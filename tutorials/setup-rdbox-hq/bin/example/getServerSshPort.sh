#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

# Usage : $0 ''

SERVER_TYPE=$1
if [ "${SERVER_TYPE}" == "" ] ; then
    echo "Usage : $0 SERVER-TYPE"
    exit 1
fi

#
case "${SERVER_TYPE}" in
    "${SERVER_TYPE_VPNSERVER}" )  echo "2200" ;;
    "${SERVER_TYPE_KUBEMASTER}" ) echo "2201" ;;
    "${SERVER_TYPE_KUBENODE}" )   echo "2202" ;;
    * )   echo "22" ;;
esac

#
