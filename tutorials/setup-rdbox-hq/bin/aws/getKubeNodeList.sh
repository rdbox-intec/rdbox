#!/bin/bash


source ${HOME}/.bashrc.rdbox-hq

#
SERVER_TYPE=${SERVER_TYPE_KUBENODE}
list_worker=`aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --filters "Name=tag:Name,Values=${RDBOX_HQ_PREF_NAME}Ec2Instance${SERVER_TYPE}*" "Name=instance-state-name,Values=running" | grep "i-" | sed -e 's#[ \"\,]##g'| sort | uniq`

echo ${list_worker}

#
