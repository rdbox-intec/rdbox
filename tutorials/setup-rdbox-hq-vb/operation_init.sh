#!/bin/bash

function usage() {
cat <<_EOT_
Usage:
  $0 operation

Description:
  Operates RDBOX-HQ init.

operation - vagrant operation (e.g. up, halt)
_EOT_
exit 1
}

if [ $# -lt 1 ]; then
  echo Invalid Args $*
  usage
  exit 1
else
  echo OK
fi

opration=$1

cd ./build-initVM || exit

vagrant $opration

cd ..
