#!/bin/bash

# shellcheck source=../conf/bashrc.rdbox-hq.example
source "${HOME}"/.bashrc.rdbox-hq

ESC=$(printf '\033')

echo ""
echo ""
echo "[INFO] START All Build. :  $(date +%Y-%m-%dT%H:%M:%S)"
echo "##########################################"
echo ""
echo ""

bash ./build_vpnserver.sh
ret_vpn=$?
if [ ${ret_vpn} -gt 0 ]; then
    printf "${ESC}[1;31m%s${ESC}[m\n" '[ERROR] Errors were detected while building the VPN server...'
    exit 11
fi
echo "Waiting to be processed...(Max 60s)"
sleep 60

bash ./build_kube_master.sh
ret_master=$?
if [ ${ret_master} -gt 0 ]; then
    printf "${ESC}[1;31m%s${ESC}[m\n" '[ERROR] Errors were detected while building the Kube Master....'
    exit 12
fi
echo "Waiting to be processed...(Max 60s)"
sleep 60

bash ./build_kube_node.sh
ret_node=$?
if [ ${ret_node} -gt 0 ]; then
    printf "${ESC}[1;31m%s${ESC}[m\n" '[ERROR] Errors were detected while building the Kube Node....'
    exit 13
fi
echo "Waiting to be processed...(Max 60s)"
sleep 30

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
    printf "${ESC}[1;36m%s${ESC}[m\n" '[INFO] Build completed.'
    echo ""
    echo "[INFO]------------------------"
    echo "VPN Server Address:"
    echo "${VPN_ADDRESS_PUBLIC}"
    echo "Kubernetes Join Command:"
    echo "${K8S_JOIN_COMMAND}"
    echo "[INFO]------------------------"
    echo ""
    # Yellow
    printf "${ESC}[1;32m%s${ESC}[m\n" '[WARN] You will need to run a test command to make sure it is built correctly.'
    echo "    \`\`\`"
    echo "    $ bash spec_all.sh"
    echo "    \`\`\`"
    echo ""
    echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"
    ret=0
else
    echo "##########################################"
    # Red
    printf "${ESC}[1;31m%s${ESC}[m\n" '[ERROR] Error detected.'
    echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"
    ret=1
fi

exit $ret
