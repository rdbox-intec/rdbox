#!/bin/bash

cd ~
mkdir ros-base-catkin
cd ros-base-catkin
echo 'FROM rdbox/ros:melodic-ros-base-bionic

RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && \
                  mkdir -p /catkin_ws/src && \
                  cd /catkin_ws/src && \
                  catkin_init_workspace && \
                  cd /catkin_ws/ && \
                  catkin_make"

COPY ./ros_entrypoint.sh /ros_entrypoint.sh
' > Dockerfile

echo '#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"
source "/catkin_ws/devel/setup.bash"
exec "$@"
chmod +x ros_entrypoint.sh
' > ros_entrypoint.sh

sudo docker build -t rdbox/ros:melodic-ros-base-catkin-bionic -f ./Dockerfile .