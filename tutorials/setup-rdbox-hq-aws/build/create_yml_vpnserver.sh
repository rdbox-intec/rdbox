#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq-aws

RDBOX_HQ_PREF_NAME="Rdboxhq"

#
TEMPL_Parameters=`cat ../templ/Parameters.templ | grep -v '^#'`
TEMPL_ParameterEntry=`cat ../templ/ParameterEntry.templ | grep -v '^#'`
TEMPL_ParameterDefault=`cat ../templ/ParameterDefault.templ | grep -v '^#'`
TEMPL_ParameterAllowedValues=`cat ../templ/ParameterAllowedValues.templ | grep -v '^#'`
TEMPL_ParameterAllowedValuesEntry=`cat ../templ/ParameterAllowedValuesEntry.templ | grep -v '^#'`
TEMPL_ParameterDescription=`cat ../templ/ParameterDescription.templ | grep -v '^#'`

#
TEMPL_Resources=`cat ../templ/Resources.templ | grep -v '^#'`
TEMPL_Ec2Instance=`cat ../templ/Ec2Instance.templ | grep -v '^#'`
TEMPL_EIPAssociation=`cat ../templ/EIPAssociation.templ | grep -v '^#'`

#
TEMPL_Outputs=`cat ../templ/Outputs.templ | grep -v '^#'`
TEMPL_Export=`cat ../templ/Export.templ | grep -v '^#'`

# Parameters
source create_yml_param_opts.sh
printf "${TEMPL_Parameters}\n"

## Parameters InstanceType
printf "${TEMPL_ParameterEntry}\n" "ParamInstanceType" "String"
printf "${TEMPL_ParameterDefault}\n" ${AWS_EC2_INSTANCE_TYPE_VpnServer}
printAllowValuesInstanceType
printf "${TEMPL_ParameterDescription}\n" "AWS::EC2::Instance"

# Resources
printf "${TEMPL_Resources}\n"

# EC2::Instance(VpnServer)
printf "${TEMPL_Ec2Instance}\n" ${AWS_NAME_Ec2InstanceVpnServer} ${AWS_DeletionPolicy} ${AWS_EC2_IMAGE_ID_VpnServer} "Ref: ParamInstanceType" ${AWS_EC2_ROOT_EBS_SIZE_VpnServer} "Exp${AWS_NAME_Subnet}" "Exp${AWS_NAME_SecurityGroup}" ${AWS_KEY_NAME} ${AWS_NAME_Ec2InstanceVpnServer}

# EIP(VpnServer)
printf "${TEMPL_EIPAssociation}\n" ${AWS_NAME_EIP_VpnServer} ${AWS_DeletionPolicy} "Exp${AWS_NAME_EIP_VpnServer}AllocationId" ${AWS_NAME_Ec2InstanceVpnServer}

#
