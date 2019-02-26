#!/bin/bash

# see also https://github.com/kubernetes/kubernetes/issues/7294
swapoff -a

#
cp -p /etc/fstab /etc/fstab.orig
grep -v swap /etc/fstab > /etc/fstab.noswap
mv /etc/fstab.noswap /etc/fstab

#
