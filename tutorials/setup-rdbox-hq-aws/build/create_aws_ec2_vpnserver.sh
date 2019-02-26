#!/bin/bash

#
FILE_YML=vpnserver.yml
bash ./create_yml_vpnserver.sh > ${FILE_YML}

#
KEY_STACK_NAME=RdboxVpnServer

#
KEY_PARAM1=ParamInstanceType
VAL_PARAM1=t2.micro
#VAL_PARAM1=t2.small
#VAL_PARAM1=t2.medium
#VAL_PARAM1=t2.large

#
aws cloudformation create-stack --stack-name ${KEY_STACK_NAME} --template-body file://./${FILE_YML} --parameters ParameterKey=${KEY_PARAM1},ParameterValue=${VAL_PARAM1}

#
