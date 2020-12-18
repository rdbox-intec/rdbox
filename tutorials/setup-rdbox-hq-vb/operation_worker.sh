#!/bin/bash

function usage() {
cat <<_EOT_
Usage:
  $0 operation [target]

Description:
  Operates RDBOX-HQ workers.

operation - vagrant operation (e.g. up, halt)
target    - hostname of woker (e.g. rdbox-worker-01)
            If not specified, all workers will be targeted for operation.

e.g.
  $ bash $0 halt rdbox-worker-01     # shutdown rdbox-worker-02
  $ bash $0 up                       # boot all host

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
target=$2
vagrant_f="Vagrantfile.*${target}.*"



cd ./build-workerVM || exit

for file in $vagrant_f; do
  echo ${file}
  cp -rf ${file} Vagrantfile
  vagrant $opration
done

cd ..
