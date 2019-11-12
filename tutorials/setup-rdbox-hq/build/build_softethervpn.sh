#!/bin/bash

source ${HOME}/.bashrc.rdbox-hq

source setenv_build_softether.sh

#
pushd . > /dev/null

#
echo "[INFO] Install some packages"
sudo apt update
sudo apt install -y apt-utils net-tools
sudo apt install -y libreadline-dev libreadline5 \
                    openssl libssl-dev libncurses5-dev zlib1g-dev \
                    bridge-utils traceroute dnsutils \
                    make gcc git ssh vim

#
mkdir -p ${HOME}/git
cd ${HOME}/git
curl -L --output ${FILE_SOFTETHER_SRC_TAR_GZ} ${URL_SOFTETHER_RELEASE}
tar xvfz ${FILE_SOFTETHER_SRC_TAR_GZ}

#
umask 022
cd ${SOFTETHER_VERSION}
./configure
make

#
cd bin
tar cfz ${HOME}/git/${FILE_SOFTETHER_BIN_TAR_GZ} ./vpn*

#
popd > /dev/null
#
