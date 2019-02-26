#!/bin/bash

#
TEMPL_Parameters=`cat ../templ/Parameters.templ | grep -v '^#'`
TEMPL_ParameterEntry=`cat ../templ/ParameterEntry.templ | grep -v '^#'`
TEMPL_ParameterDefault=`cat ../templ/ParameterDefault.templ | grep -v '^#'`
TEMPL_ParameterAllowedValues=`cat ../templ/ParameterAllowedValues.templ | grep -v '^#'`
TEMPL_ParameterAllowedValuesEntry=`cat ../templ/ParameterAllowedValuesEntry.templ | grep -v '^#'`
TEMPL_ParameterDescription=`cat ../templ/ParameterDescription.templ | grep -v '^#'`

function printAllowValuesInstanceType {
    printf "${TEMPL_ParameterAllowedValues}\n"
    printf "${TEMPL_ParameterAllowedValuesEntry}\n" ${AWS_EC2_INSTANCE_TYPE_MICRO}
    printf "${TEMPL_ParameterAllowedValuesEntry}\n" ${AWS_EC2_INSTANCE_TYPE_SMALL}
    printf "${TEMPL_ParameterAllowedValuesEntry}\n" ${AWS_EC2_INSTANCE_TYPE_MEDIUM}
    printf "${TEMPL_ParameterAllowedValuesEntry}\n" ${AWS_EC2_INSTANCE_TYPE_LARGE}
}

function printAllowValuesKubeNodeName {
    printf "${TEMPL_ParameterAllowedValues}\n"
    for no in `seq 10` ; do
        printf "${TEMPL_ParameterAllowedValuesEntry}\n" `printf "${AWS_NAME_Ec2InstanceKubeNode}%02d" $no`
    done
}

function printAllowValuesAvailabilityZone {
    LST_AvailabilityZone=`aws ec2 describe-availability-zones --region ap-northeast-1 | grep 'ZoneName' | sed -e 's#\s##g' | cut -d':' -f 2 | cut -d'"' -f 2`
    printf "${TEMPL_ParameterAllowedValues}\n"
    for zone in ${LST_AvailabilityZone} ; do
        printf "${TEMPL_ParameterAllowedValuesEntry}\n" ${zone}
    done
}

#
