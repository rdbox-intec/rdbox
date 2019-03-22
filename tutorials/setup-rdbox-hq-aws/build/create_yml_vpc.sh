#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq-aws

#
TEMPL_Resources=`cat ../templ/Resources.templ | grep -v '^#'`
TEMPL_VPC=`cat ../templ/VPC.templ | grep -v '^#'`
TEMPL_Subnet=`cat ../templ/Subnet.templ | grep -v '^#'`
TEMPL_EIP=`cat ../templ/EIP.templ | grep -v '^#'`
TEMPL_InternetGateway=`cat ../templ/InternetGateway.templ | grep -v '^#'`
TEMPL_DHCPOptions=`cat ../templ/DHCPOptions.templ | grep -v '^#'`
TEMPL_RouteTable=`cat ../templ/RouteTable.templ | grep -v '^#'`
TEMPL_Route=`cat ../templ/Route.templ | grep -v '^#'`
TEMPL_SecurityGroup=`cat ../templ/SecurityGroup.templ | grep -v '^#'`
TEMPL_SecurityGroupIngress=`cat ../templ/SecurityGroupIngress.templ | grep -v '^#'`
TEMPL_Ec2Instance=`cat ../templ/Ec2Instance.templ | grep -v '^#'`

#
TEMPL_Outputs=`cat ../templ/Outputs.templ | grep -v '^#'`
TEMPL_Export=`cat ../templ/Export.templ | grep -v '^#'`

# Parameters
source create_yml_param_opts.sh
printf "${TEMPL_Parameters}\n"

## Parameters AvailabilityZone
printf "${TEMPL_ParameterEntry}\n" "ParamAvailabilityZone" "String"
printAllowValuesAvailabilityZone
printf "${TEMPL_ParameterDescription}\n" "AvailabilityZone"

# Resources
printf "${TEMPL_Resources}\n"

# VPC
printf "${TEMPL_VPC}\n" ${AWS_NAME_VPC} ${AWS_DeletionPolicy} ${AWS_VPC_CIDR} ${AWS_VPC_DnsSupport} ${AWS_VPC_DnsHostnames} ${AWS_NAME_VPC}

# InternetGateway
printf "${TEMPL_InternetGateway}\n" ${AWS_NAME_InternetGateway} ${AWS_DeletionPolicy} ${AWS_NAME_InternetGateway} ${AWS_NAME_InternetGateway} ${AWS_NAME_InternetGateway} ${AWS_NAME_VPC}

# DHCPOptions
printf "${TEMPL_DHCPOptions}\n" ${AWS_NAME_DHCPOptions} ${AWS_DeletionPolicy} ${AWS_DomainName} ${AWS_DomainNameServers} ${AWS_NAME_DHCPOptions} ${AWS_NAME_DHCPOptions} ${AWS_NAME_DHCPOptions} ${AWS_NAME_VPC}

# RouteTable
printf "${TEMPL_RouteTable}\n" ${AWS_NAME_RouteTable} ${AWS_DeletionPolicy} ${AWS_NAME_VPC} ${AWS_NAME_RouteTable}

# Route
printf "${TEMPL_Route}\n" ${AWS_NAME_Route} ${AWS_DeletionPolicy} ${AWS_NAME_RouteTable} ${AWS_DestinationCidrBlock} ${AWS_NAME_InternetGateway}

# Subnet
printf "${TEMPL_Subnet}\n" ${AWS_NAME_Subnet} ${AWS_DeletionPolicy} "Ref: ParamAvailabilityZone" ${AWS_VPC_CIDR} ${AWS_NAME_VPC} ${AWS_NAME_Subnet} ${AWS_NAME_Subnet} ${AWS_NAME_RouteTable} ${AWS_NAME_Subnet}

#
printf "${TEMPL_SecurityGroup}\n" ${AWS_NAME_SecurityGroup} ${AWS_DeletionPolicy} ${AWS_NAME_SecurityGroup} ${AWS_NAME_SecurityGroup} ${AWS_NAME_VPC} ${AWS_NAME_SecurityGroup}

# sequence number for SecurityGroupIngress
SEQ_NO_POOL=(`seq 100`)
FMT_NAME_SecurityGroupIngress="${RDBOX_HQ_PREF_NAME}SecurityGroupIngress%05d"

#
for SG_ALLOW in `echo ${AWS_SecurityGroupAllowPrivate} ${AWS_SecurityGroupAllowGlobal} | tr ',' ' '` ; do
    AWS_SGI_CidrIp="${SG_ALLOW}"
    for SG_ALLOW_Protocol in "tcp" ; do
        AWS_SGI_IpProtocol=${SG_ALLOW_Protocol}
        for SG_ALLOW_PORT in 22 443 30443 ; do
            #
            SEQ_NO=${SEQ_NO_POOL[0]} ; SEQ_NO_POOL=("${SEQ_NO_POOL[@]:1}")
            AWS_NAME_SecurityGroupIngress=`printf "${FMT_NAME_SecurityGroupIngress}" ${SEQ_NO}`
            AWS_SGI_FromPort=${SG_ALLOW_PORT}
            AWS_SGI_ToPort=${SG_ALLOW_PORT}
            printf "${TEMPL_SecurityGroupIngress}\n" ${AWS_NAME_SecurityGroupIngress} ${AWS_DeletionPolicy} ${AWS_NAME_SecurityGroup} ${AWS_SGI_IpProtocol} ${AWS_SGI_FromPort} ${AWS_SGI_ToPort} ${AWS_SGI_CidrIp} ${AWS_NAME_SecurityGroupIngress}
        done
    done
done

#
for SG_ALLOW in "10.0.0.0/8" "${RDBOX_NET_CIDR}" "${AWS_VPC_CIDR}" ; do
    AWS_SGI_CidrIp="${SG_ALLOW}"
    for SG_ALLOW_Protocol in "tcp" "udp" ; do
        AWS_SGI_IpProtocol=${SG_ALLOW_Protocol}

        #
        SEQ_NO=${SEQ_NO_POOL[0]} ; SEQ_NO_POOL=("${SEQ_NO_POOL[@]:1}")
        AWS_NAME_SecurityGroupIngress=`printf "${FMT_NAME_SecurityGroupIngress}" ${SEQ_NO}`
        AWS_SGI_FromPort=0
        AWS_SGI_ToPort=65535
        printf "${TEMPL_SecurityGroupIngress}\n" ${AWS_NAME_SecurityGroupIngress} ${AWS_DeletionPolicy} ${AWS_NAME_SecurityGroup} ${AWS_SGI_IpProtocol} ${AWS_SGI_FromPort} ${AWS_SGI_ToPort} ${AWS_SGI_CidrIp} ${AWS_NAME_SecurityGroupIngress}
    done
done

#
SEQ_NO=${SEQ_NO_POOL[0]} ; SEQ_NO_POOL=("${SEQ_NO_POOL[@]:1}")
AWS_NAME_SecurityGroupIngress=`printf "${FMT_NAME_SecurityGroupIngress}" ${SEQ_NO}`
AWS_SGI_IpProtocol="icmp"
AWS_SGI_FromPort=-1
AWS_SGI_ToPort=-1
AWS_SGI_CidrIp="0.0.0.0/0"
printf "${TEMPL_SecurityGroupIngress}\n" ${AWS_NAME_SecurityGroupIngress} ${AWS_DeletionPolicy} ${AWS_NAME_SecurityGroup} ${AWS_SGI_IpProtocol} ${AWS_SGI_FromPort} ${AWS_SGI_ToPort} ${AWS_SGI_CidrIp} ${AWS_NAME_SecurityGroupIngress}

# EIP(VpnServer)
printf "${TEMPL_EIP}\n" ${AWS_NAME_EIP_VpnServer} ${AWS_DeletionPolicy}

# EIP(KubeMaster)
printf "${TEMPL_EIP}\n" ${AWS_NAME_EIP_KubeMaster} ${AWS_DeletionPolicy}

##### Export #####
printf "${TEMPL_Outputs}\n"

printf "${TEMPL_Export}\n" ${AWS_NAME_VPC} "!Ref" ${AWS_NAME_VPC} ${AWS_NAME_VPC}
printf "${TEMPL_Export}\n" ${AWS_NAME_Subnet} "!Ref" ${AWS_NAME_Subnet} ${AWS_NAME_Subnet}
printf "${TEMPL_Export}\n" ${AWS_NAME_SecurityGroup} "!Ref" ${AWS_NAME_SecurityGroup} ${AWS_NAME_SecurityGroup}
printf "${TEMPL_Export}\n" ${AWS_NAME_EIP_VpnServer} "!Ref" "${AWS_NAME_EIP_VpnServer}" ${AWS_NAME_EIP_VpnServer}
printf "${TEMPL_Export}\n" ${AWS_NAME_EIP_KubeMaster} "!Ref" "${AWS_NAME_EIP_KubeMaster}" ${AWS_NAME_EIP_KubeMaster}
printf "${TEMPL_Export}\n" "${AWS_NAME_EIP_VpnServer}AllocationId" "!GetAtt" "${AWS_NAME_EIP_VpnServer}.AllocationId" "${AWS_NAME_EIP_VpnServer}AllocationId"
printf "${TEMPL_Export}\n" "${AWS_NAME_EIP_KubeMaster}AllocationId" "!GetAtt" "${AWS_NAME_EIP_KubeMaster}.AllocationId" "${AWS_NAME_EIP_KubeMaster}AllocationId"

#
