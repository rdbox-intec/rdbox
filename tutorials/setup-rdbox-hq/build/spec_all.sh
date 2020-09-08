#!/bin/bash

echo "[INFO] START All Tests. :  $(date +%Y-%m-%dT%H:%M:%S)"
echo "##########################################"

bash ./spec_vpnserver.sh
ret_vpn=$?
bash ./spec_kube_master.sh
ret_master=$?
bash ./spec_kube_node.sh
ret_node=$?

ret=0
if [ ${ret_vpn} = 0 ] && [ ${ret_master} = 0 ] && [ ${ret_node} = 0 ]; then
    echo "##########################################"
    echo "[INFO] Passed All Tests."
    echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"
    ret=0
else
    echo "##########################################"
    echo "[ERROR] Error detected."
    echo "[INFO] DONE :  $(date +%Y-%m-%dT%H:%M:%S)"
    ret=1
fi

exit $ret