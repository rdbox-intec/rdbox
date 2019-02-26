#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
if [ ! -e "${HOME}/.kube/dashboard/" ] ; then
    mkdir -p ${HOME}/.kube/dashboard/
    chmod 750 ${HOME}/.kube/dashboard/
fi

# create kubernetes-dashboard.yml.patch
cat << EOS_RDBOX > ${HOME}/rdbox/tmp/kubernetes-dashboard.yml.patch
--- kubernetes-dashboard.yml.orig       2019-02-20 07:56:52.992182305 +0000
+++ kubernetes-dashboard.yml    2019-02-20 07:57:38.208066824 +0000
@@ -115,6 +115,7 @@ spec:
           protocol: TCP
         args:
           - --auto-generate-certificates
+          - --token-ttl=${KUBE_DASHBOARD_TOKEN_TTL}
           # Uncomment the following line to manually specify Kubernetes API server Host
           # If not specified, Dashboard will attempt to auto discover the API server and connect
           # to it. Uncomment only if the default does not work.
@@ -143,6 +144,8 @@ spec:
       tolerations:
       - key: node-role.kubernetes.io/master
         effect: NoSchedule
+      nodeSelector:
+        beta.kubernetes.io/arch: amd64

 ---
 # ------------------- Dashboard Service ------------------- #
@@ -158,5 +161,7 @@ spec:
   ports:
     - port: 443
       targetPort: 8443
+      nodePort: ${KUBE_DASHBOARD_PORT}
   selector:
     k8s-app: kubernetes-dashboard
+  type: NodePort
EOS_RDBOX

# create patch for dashboard
curl --silent --output ${HOME}/rdbox/tmp/kubernetes-dashboard.yml https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.0/src/deploy/recommended/kubernetes-dashboard.yaml

patch ${HOME}/rdbox/tmp/kubernetes-dashboard.yml < ${HOME}/rdbox/tmp/kubernetes-dashboard.yml.patch 

#
