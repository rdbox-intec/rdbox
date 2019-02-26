#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

# Usage : $0 'RdboxhqEc2InstanceVpnServer'

SERVER_TYPE=$1
if [ "${SERVER_TYPE}" == "" ] ; then
    echo "Usage : $0 SERVER-TYPE [instancd-id]"
    exit 1
fi

LIST_InstanceId=$2
if [ "$2" = "" ] ; then
    LIST_InstanceId=`aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --filters "Name=tag:Name,Values=${RDBOX_HQ_PREF_NAME}Ec2Instance${SERVER_TYPE}*" "Name=instance-state-name,Values=running" | grep "i-" | sed -e 's#[ \"\,]##g'| sort | uniq`
    if [ "${LIST_InstanceId}" == "" ] ; then
        echo "[ERROR] Cannot found server '${SERVER_TYPE}'"
        exit 1
    fi
fi

#
# AWS 'PublicDnsName' is too long.
#   e.g. ec2-12-34-56-78.ap-northeast-1.compute.amazonaws.com
# Ansible failed to create unix domain socket.
#   > "/root/.ansible/cp/ansible-ssh-ec2-12-34-56-78.ap-northeast-1.compute.amazonaws.com-22-ubuntu.R6SSkL7U8m78NwiD"
#   > too long for Unix domain socket
for InstanceId in ${LIST_InstanceId} ; do
    server_address=`aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --filters "Name=instance-id,Values=${InstanceId}"  | grep -e '[0-9]' | sed -e 's#[\"]##g'`
    echo ${server_address}
done

#
