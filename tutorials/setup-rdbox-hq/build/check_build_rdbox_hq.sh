#!/bin/bash

print_usage() {
    echo "USAGE : $0 [ -v ]"
}
while getopts "v" OPT
do
    case $OPT in
        v) MODE_VERBOSE="on"
          ;;
    esac
done
shift $(($OPTIND - 1))

# init
STA=0

#
function mask_value () {
    if [ "${MODE_VERBOSE}" != "" ] ; then
        echo $1
    else
        echo $1 | sed -e 's#.#*#g'
    fi
}

#
if [ ! -e "${HOME}/.bashrc.rdbox-hq" ] ; then
    echo "[ERROR] Can not found '${HOME}/.bashrc.rdbox-hq'"
    STA=1
    exit $STA
fi
echo "[INFO] reading... '${HOME}/.bashrc.rdbox-hq'"
source ${HOME}/.bashrc.rdbox-hq

echo "Checking... 'RDBOX_HQ_BUILD_PF'=${RDBOX_HQ_BUILD_PF}"
if [ "${RDBOX_HQ_BUILD_PF}" = "vb" ] ; then
    echo "passed."
    echo "[INFO] This is 'VirtualBox' setup mode."
elif [ "${RDBOX_HQ_BUILD_PF}" = "aws" ] ; then
    echo "passed."
    echo "[INFO] This is 'AWS' setup mode."
else
    echo "[ERROR] You must set 'RDBOX_HQ_BUILD_PF' value."
    echo "[ERROR] e.g. 'vb' or 'aws'"
    echo "[INFO] Please edit '${HOME}/.bashrc.rdbox-hq'"
    STA=1
fi
echo ''

#
DISP_VAL=`mask_value ${VPN_HUB_PASS}`
echo "Checking... 'VPN_HUB_PASS'=${DISP_VAL}"
if [ "${VPN_HUB_PASS}" = "" ] ; then
    echo "[ERROR] You must set 'VPN_HUB_PASS' value."
    echo "[INFO] Please edit '${HOME}/.bashrc.rdbox-hq'"
    STA=1
elif [ "${VPN_HUB_PASS}" = "rdbox_password" ] ; then
    echo "[WARNING] You must change 'VPN_HUB_PASS' value."
    echo "[INFO] Please edit '${HOME}/.bashrc.rdbox-hq'"
    STA=1
else
    echo "passed."
fi
echo ''

#
DISP_VAL=`mask_value ${VPN_USER_PASS}`
echo "Checking... 'VPN_USER_PASS'=${DISP_VAL}"
if [ "${VPN_USER_PASS}" = "" ] ; then
    echo "[ERROR] You must set 'VPN_USER_PASS' value."
    echo "[INFO] Please edit '${HOME}/.bashrc.rdbox-hq'"
    STA=1
elif [ "${VPN_USER_PASS}" = "pass_rdbox" ] ; then
    echo "[WARNING] You must change 'VPN_USER_PASS' value."
    echo "[INFO] Please edit '${HOME}/.bashrc.rdbox-hq'"
    STA=1
else
    echo "passed."
fi
echo ''

#
echo "[INFO] reading... 'setenv_build_softether.sh'"
source setenv_build_softether.sh

#
echo "Checking... SoftEther-bin : ${FILE_SOFTETHER_BIN_TAR_GZ}"
if [ ! -e "${HOME}/git/${FILE_SOFTETHER_BIN_TAR_GZ}" ] ; then
    echo "[ERROR] Cannot found file. :: ${FILE_SOFTETHER_BIN_TAR_GZ}"
    echo "[INFO] Please execute build_softethervpn.sh first."
    STA=1
else
    echo "passed."
fi
echo ''


#
if [ "${STA}" != "0" ] ; then
    exit $STA
fi

#
