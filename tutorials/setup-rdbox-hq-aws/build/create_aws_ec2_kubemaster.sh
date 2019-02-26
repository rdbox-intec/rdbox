#!/bin/bash

#
FILE_YML=kube_master.yml
bash ./create_yml_kube_master.sh > ${FILE_YML}

#
KEY_STACK_NAME=RdboxKubeMaster

#
KEY_PARAM1=ParamInstanceType
VAL_PARAM1=t2.medium
#VAL_PARAM1=t2.large

#
aws cloudformation create-stack --stack-name ${KEY_STACK_NAME} --template-body file://./${FILE_YML} --parameters ParameterKey=${KEY_PARAM1},ParameterValue=${VAL_PARAM1}

#
