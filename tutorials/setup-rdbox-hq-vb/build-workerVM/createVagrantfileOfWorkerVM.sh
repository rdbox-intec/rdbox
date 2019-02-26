#!/bin/sh

RDBOX_CONFIG=../conf/rdbox-hq-vb.params

#
#--- DO NOT MODIFY UNDER THIS LINE ---
#

perl ../bin/createVagrantfile.pl -i ../conf/Vagrantfile.in.worker -p $RDBOX_CONFIG

VMNAME=`grep config.vm.define Vagrantfile |sed -e 's/\"/ /g'|awk '{print $2}'`
CREATETIME=`date +"%Y%m%d-%H%M%S"`
VMFILENAME="Vagrantfile.$VMNAME.$CREATETIME"
cp -pf Vagrantfile $VMFILENAME
