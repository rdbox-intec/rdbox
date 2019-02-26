#!/bin/bash

if [ ! -e "${HOME}/.ssh/id_rsa.pub" ] ; then
    CMD="ssh-keygen -t rsa -b 4096"
    echo "[INFO] Can not found '${HOME}/.ssh/id_rsa.pub'"
    echo "Create SSH key(Exec : ${CMD})"
    ${CMD}
fi

ssh-copy-id $@
