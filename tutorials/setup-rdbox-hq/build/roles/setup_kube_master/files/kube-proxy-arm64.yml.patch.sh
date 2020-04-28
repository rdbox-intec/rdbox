#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

cat << EoPatch
--- kube-proxy.yml.orig 2019-01-08 01:48:16.336980589 +0000
+++ kube-proxy-arm64.yml  2019-01-08 01:52:14.696980589 +0000
@@ -112,7 +112,7 @@ metadata:
     fieldsV1:
     manager: kube-controller-manager
     operation: Update
-  name: kube-proxy
+  name: kube-proxy-arm64
   namespace: kube-system
 spec:
   selector:
@@ -137,7 +137,7 @@ spec:
             fieldRef:
               apiVersion: v1
               fieldPath: spec.nodeName
-        image: k8s.gcr.io/kube-proxy:v${KUBERNETES_VERSION}
+        image: k8s.gcr.io/kube-proxy-arm64:v${KUBERNETES_VERSION}
         imagePullPolicy: IfNotPresent
         name: kube-proxy
         resources: {}
@@ -157,6 +157,7 @@ spec:
       hostNetwork: true
       nodeSelector:
         kubernetes.io/os: linux
+        beta.kubernetes.io/arch: arm64
       priorityClassName: system-node-critical
       restartPolicy: Always
       schedulerName: default-scheduler
EoPatch
