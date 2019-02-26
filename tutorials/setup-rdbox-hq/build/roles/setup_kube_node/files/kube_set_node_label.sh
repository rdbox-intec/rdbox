#!/bin/bash

#
kubectl --kubeconfig /etc/kubernetes/admin.conf label node `hostname` node.rdbox.com/location=hq

#
