#!/bin/bash

#
NODE_NO=$1
if [ "${NODE_NO}" = "" ] ; then
    echo "[ERROR] require NODE_NO"
    echo "[INFO] e.g.  $0 1"
    exit 1
fi
if [ ${NODE_NO} -le 0 ] ; then
    echo "[ERROR] Invalid NODE_NO : ${NODE_NO}"
    echo "[INFO] NODE_NO range is  1 to 10"
    exit 1
fi
if [ ${NODE_NO} -gt 10 ] ; then
    echo "[ERROR] Invalid NODE_NO : ${NODE_NO}"
    echo "[INFO] NODE_NO range is  1 to 10"
    exit 1
fi

#
FILE_YML=kube_node.yml
bash ./create_yml_kube_node.sh > ${FILE_YML}

#
KEY_STACK_NAME=`printf "RdboxKubeNode%02d" ${NODE_NO}`

#
KEY_PARAM1=ParamInstanceType
VAL_PARAM1=t2.micro
#VAL_PARAM1=t2.small
#VAL_PARAM1=t2.medium
#VAL_PARAM1=t2.large

#
KEY_PARAM2=ParamKubeNodeName
VAL_PARAM2=`printf "RdboxhqEc2InstanceKubeNode%02d" ${NODE_NO}`

#
aws cloudformation create-stack --stack-name ${KEY_STACK_NAME} --template-body file://./${FILE_YML} --parameters ParameterKey=${KEY_PARAM1},ParameterValue=${VAL_PARAM1} ParameterKey=${KEY_PARAM2},ParameterValue=${VAL_PARAM2}

#
