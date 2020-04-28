#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

#
if [ ! -e "${HOME}/.kube/dashboard/" ] ; then
    mkdir -p ${HOME}/.kube/dashboard/
    chmod 750 ${HOME}/.kube/dashboard/
fi

# create kubernetes-dashboard.yml.patch
cat << EOS_RDBOX > ${HOME}/rdbox/tmp/kubernetes-dashboard.yml.patch
--- recommended.orig.yaml	2020-04-20 01:11:04.895950760 +0000
+++ recommended.yaml	2020-04-20 01:29:11.524514758 +0000
@@ -40,8 +40,10 @@ spec:
   ports:
     - port: 443
       targetPort: 8443
+      nodePort: ${KUBE_DASHBOARD_PORT}
   selector:
     k8s-app: kubernetes-dashboard
+  type: NodePort
 
 ---
 
@@ -195,6 +197,7 @@ spec:
           args:
             - --auto-generate-certificates
             - --namespace=kubernetes-dashboard
+            - --token-ttl=${KUBE_DASHBOARD_TOKEN_TTL}
             # Uncomment the following line to manually specify Kubernetes API server Host
             # If not specified, Dashboard will attempt to auto discover the API server and connect
             # to it. Uncomment only if the default does not work.
@@ -226,6 +229,7 @@ spec:
       serviceAccountName: kubernetes-dashboard
       nodeSelector:
         "kubernetes.io/os": linux
+        "beta.kubernetes.io/arch": amd64
       # Comment the following tolerations if Dashboard must not be deployed on master
       tolerations:
         - key: node-role.kubernetes.io/master
@@ -293,6 +297,7 @@ spec:
       serviceAccountName: kubernetes-dashboard
       nodeSelector:
         "kubernetes.io/os": linux
+        "beta.kubernetes.io/arch": amd64
       # Comment the following tolerations if Dashboard must not be deployed on master
       tolerations:
         - key: node-role.kubernetes.io/master
EOS_RDBOX

# create patch for dashboard
curl --silent --output ${HOME}/rdbox/tmp/kubernetes-dashboard.yml https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

patch ${HOME}/rdbox/tmp/kubernetes-dashboard.yml < ${HOME}/rdbox/tmp/kubernetes-dashboard.yml.patch 

#
