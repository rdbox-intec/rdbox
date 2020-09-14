#!/bin/bash

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

ESC=$(printf '\033')

echo ""
echo ""
echo "[INFO] START All Tests. :  $(date +%Y-%m-%dT%H:%M:%S)"
echo "##########################################"
echo ""
echo ""

bash ./spec_vpnserver.sh
ret_vpn=$?
bash ./spec_kube_master.sh
ret_master=$?
bash ./spec_kube_node.sh
ret_node=$?

ret=0
if [ ${ret_vpn} = 0 ] && [ ${ret_master} = 0 ] && [ ${ret_node} = 0 ]; then
    pushd . > /dev/null
    cd ../bin/"${RDBOX_HQ_BUILD_PF}" || exit
    VPN_ADDRESS_PUBLIC=$(./getServerAddressPublic.sh "VpnServer")
    popd > /dev/null || exit
    K8S_JOIN_COMMAND=$(./print_kube_join_command.sh 2>/dev/null)
    echo ""
    echo "##########################################"
    # Blue
    printf "${ESC}[1;36m%s${ESC}[m\n" '[INFO] Passed All Tests.'
    echo ""
    echo "[INFO]------------------------"
    echo "VPN Server Address:"
    echo "${VPN_ADDRESS_PUBLIC}"
    echo "Kubernetes Join Command:"
    echo "${K8S_JOIN_COMMAND}"
    echo "[INFO]------------------------"
    echo ""
    # Yellow
    printf "${ESC}[1;32m%s${ESC}[m\n" '[WARN] Finally, you should make sure that the STATUS of each Kubernetes node is set to Ready.'
    printf "${ESC}[1;32m%s${ESC}[m\n" '[WARN] The result of obtaining the node information is as follows.'
    bash ./print_kubectl_get_node.sh 2>/dev/null
    ret=$?
    echo ""
    echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"
else
    echo "##########################################"
    # Red
    printf "${ESC}[1;31m%s${ESC}[m\n" '[ERROR] Error detected.'
    echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"
    ret=1
fi

exit $ret