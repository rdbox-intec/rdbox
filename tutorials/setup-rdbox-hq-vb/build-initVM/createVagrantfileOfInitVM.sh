#!/bin/sh

RDBOX_CONFIG=../conf/rdbox-hq-vb.params

#
#--- DO NOT MODIFY UNDER THIS LINE ---
#

perl ../bin/createVagrantfile.pl -i ../conf/Vagrantfile.in.init -p $RDBOX_CONFIG

CREATETIME=$(date +"%Y%m%d-%H%M%S")
VMFILENAME="Vagrantfile.$CREATETIME"
cp -pf Vagrantfile "$VMFILENAME"
