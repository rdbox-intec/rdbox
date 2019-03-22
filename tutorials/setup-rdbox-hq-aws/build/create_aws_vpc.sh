#!/bin/bash

. ${HOME}/.bashrc.rdbox-hq-aws

#
FILE_YML=vpc.yml
bash ./create_yml_vpc.sh > ${FILE_YML}

#
KEY_STACK_NAME="${RDBOX_HQ_PREF_NAME}-Vpc"

#
KEY_PARAM1=ParamAvailabilityZone
VAL_PARAM1=ap-northeast-1a
#VAL_PARAM1=ap-northeast-1c
#VAL_PARAM1=ap-northeast-1d

#
aws cloudformation create-stack --stack-name ${KEY_STACK_NAME} --template-body file://./${FILE_YML} --parameters ParameterKey=${KEY_PARAM1},ParameterValue=${VAL_PARAM1}

#
