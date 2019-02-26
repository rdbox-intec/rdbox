#!/bin/sh

set -e

TB3MODEL_INITIAL=`echo -n $ROS_HOSTNAME | cut -c4`

if [ $TB3MODEL_INITIAL = b ]; then
    OPENCR_MODEL="burger"
elif [ $TB3MODEL_INITIAL = w ]; then
    OPENCR_MODEL="waffle"
else
    OPENCR_MODEL="burger"
fi

rm -rf ./opencr_update.tar.bz2
wget https://github.com/ROBOTIS-GIT/OpenCR/raw/$OPENCR_VERSION/arduino/opencr_release/shell_update/opencr_update.tar.bz2 
tar -xvf opencr_update.tar.bz2
cd ./opencr_update
./update.sh $OPENCR_PORT $OPENCR_MODEL.opencr
