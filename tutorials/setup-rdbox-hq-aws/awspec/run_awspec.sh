#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq
source ${HOME}/.bashrc.rdbox-hq.aws

shell_vars=`set | grep -e RDBOX -e AWS`
while read line
do
#    echo "export $line"
    eval "export $line"
done << EOB
${shell_vars}
EOB

bundle exec rake spec

#
