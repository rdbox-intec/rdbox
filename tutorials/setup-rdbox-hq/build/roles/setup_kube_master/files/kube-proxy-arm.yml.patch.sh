#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

cat << EoPatch
--- kube-proxy.yml.orig 2019-01-08 01:48:16.336980589 +0000
+++ kube-proxy-arm.yml  2019-01-08 01:52:14.696980589 +0000
@@ -3,7 +3,7 @@ kind: DaemonSet
 metadata:
   labels:
     k8s-app: kube-proxy
-  name: kube-proxy
+  name: kube-proxy-arm
   namespace: kube-system
 spec:
   selector:
@@ -27,7 +27,7 @@ spec:
             fieldRef:
               apiVersion: v1
               fieldPath: spec.nodeName
-        image: k8s.gcr.io/kube-proxy:v${KUBERNETES_VERSION}
+        image: k8s.gcr.io/kube-proxy-arm:v${KUBERNETES_VERSION}
         imagePullPolicy: IfNotPresent
         name: kube-proxy
         resources: {}
@@ -46,6 +46,8 @@ spec:
           readOnly: true
       dnsPolicy: ClusterFirst
       hostNetwork: true
+      nodeSelector:
+        beta.kubernetes.io/arch: arm
       priorityClassName: system-node-critical
       restartPolicy: Always
       schedulerName: default-scheduler
EoPatch
