FROM rdbox/arm.ros:kinetic-ros-base_catkin-ws

RUN apt-get update && apt-get install -y \
    ros-kinetic-multimaster-fkie \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  catkin_create_pkg multimaster_fkie_launch std_msgs && \
                  mkdir -p /catkin_ws/src/multimaster_fkie_launch/launch"

COPY ./master_discovery_fkie.launch /catkin_ws/src/multimaster_fkie_launch/launch/master_discovery_fkie.launch
COPY ./master_sync_fkie.launch /catkin_ws/src/multimaster_fkie_launch/launch/master_sync_fkie.launch

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/ && \
                  catkin_make"

