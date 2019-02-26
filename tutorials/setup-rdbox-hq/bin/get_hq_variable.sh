#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq
if [ -e "${HOME}/.bashrc.rdbox-hq-aws" ] ; then
    source ${HOME}/.bashrc.rdbox-hq-aws
fi

KEY=$1
eval "echo \${${KEY}}"
