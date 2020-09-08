#!/bin/bash

# for DEBUG verbose message level
#VERBOSE=-vvv
#VERBOSE=-vvvv

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

source check_build_rdbox_hq.sh

#
print_usage() {
    echo "USAGE : $0 [ -v VPN_SERVER_ADDRESS ] [ -m KUBE_MASTER_ADDRESS ] NODE_NAME_1 [ ... NODE_NAME_N]"
}
while getopts "v:m:" OPT
do
    case $OPT in
        v) VPN_SERVER_ADDRESS=$OPTARG
          ;;
        m) KUBE_MASTER_ADDRESS=$OPTARG
          ;;
        *) echo "Invalid arguments"
          exit 1 ;;
    esac
done
shift $((OPTIND - 1))

#
SERVER_TYPE=${SERVER_TYPE_KUBENODE}

#
pushd . > /dev/null
cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
if [ "${VPN_SERVER_ADDRESS}" = "" ] ; then
    VPN_SERVER_ADDRESS=$(./getServerAddressPrivateVpnserver.sh)
fi
echo "[INFO] USE VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS}"
if [ "${KUBE_MASTER_ADDRESS}" = "" ] ; then
    KUBE_MASTER_ADDRESS=$(bash ./getServerAddressPublic.sh "${SERVER_TYPE_KUBEMASTER}")
fi
echo "[INFO] USE KUBE_MASTER_ADDRESS=${KUBE_MASTER_ADDRESS}"
KUBE_MASTER_ADDRESS_BUILD=$(bash ./getServerAddressBuild.sh "${SERVER_TYPE_KUBEMASTER}")
LIST_kube_node=$(./getKubeNodeList.sh)
popd > /dev/null || exit

#
echo "[INFO] START : $(date +%Y-%m-%dT%H:%M:%S)"

#
FILE_KUBE_CONFIG="${HOME}/rdbox/fetch/${KUBE_MASTER_ADDRESS_BUILD}/.kube/config"
if [ ! -e "${FILE_KUBE_CONFIG}" ] ; then
    echo "[ERROR] Cannot found file. file://${FILE_KUBE_CONFIG}"
    exit 1
fi
cp -p "${FILE_KUBE_CONFIG}" roles/setup_kube_node/files/

#
./print_kube_join_command.sh | tee "${HOME}"/rdbox/tmp/print_kube_join.out
grep 'discovery-token-ca-cert-hash' "${HOME}"/rdbox/tmp/print_kube_join.out | sed -e 's/.$/ --ignore-preflight-errors=SystemVerification/g' > roles/setup_kube_node/files/kube_join.sh

#
echo "[${SERVER_TYPE}]" > inventory."${SERVER_TYPE}"
for kube_node in ${LIST_kube_node} ;
do
    #
    echo "[INFO] ${kube_node}"

    #
    pushd . > /dev/null
    cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
    SERVER_SSH_PORT=$(./getServerSshPort.sh "${SERVER_TYPE}" "${kube_node}")
    SERVER_ADDRESS=$(./getServerAddressBuild.sh "${SERVER_TYPE}" "${kube_node}")
    popd > /dev/null || exit

    #
    if [ "${SERVER_SSH_PORT}" != "" ] ; then
        # update host certs in ${HOME}/.ssh/known_hosts
        if [ "${SERVER_SSH_PORT}" != "22" ] ; then
            if [ "${SERVER_ADDRESS}" = "localhost" ] ; then
                ssh-keygen -R "[localhost]:${SERVER_SSH_PORT}" > /dev/null 2>&1
            else
                ssh-keygen -R "${SERVER_ADDRESS}:${SERVER_SSH_PORT}" > /dev/null 2>&1
            fi
        else
            ssh-keygen -R "${SERVER_ADDRESS}" > /dev/null 2>&1
        fi
        echo "${SERVER_ADDRESS} ansible_port=${SERVER_SSH_PORT}" >> inventory."${SERVER_TYPE}"
    else
        echo "[WARNIG] ${kube_node} :: Cannot found ssh-port@${SERVER_ADDRESS}"
        continue
    fi
done

#
#OPTS_BECOME_PASS="--ask-become-pass"
export ANSIBLE_HOST_KEY_CHECKING=False
OPTS_EXTRA_VARS="VPN_SERVER_ADDRESS=${VPN_SERVER_ADDRESS} RDBOX_HQ_BUILD_PF=${RDBOX_HQ_BUILD_PF} FILE_PRIVATE_KEY=${FILE_PRIVATE_KEY} FILE_PUBLIC_KEY=${FILE_PUBLIC_KEY} SUDO_USER=${ANSIBLE_REMOTE_USER}"
ansible-playbook ${VERBOSE:+""} --timeout 120 -i inventory."${SERVER_TYPE}" ${OPTS_BECOME_PASS:+""} -u "${ANSIBLE_REMOTE_USER}" --private-key="${FILE_PRIVATE_KEY}" --extra-vars "${OPTS_EXTRA_VARS}" "${SERVER_TYPE}".yml

#
echo "[INFO] Restart dnsmasq server on K8s master node."
pushd . > /dev/null
cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
bash ./restartDnsmasqServer.sh
popd > /dev/null || exit

#
echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"