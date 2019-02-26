FROM rdbox/arm.ros:kinetic-ros-base

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  mkdir -p /catkin_ws/src && \
                  cd /catkin_ws/src && \
                  catkin_init_workspace && \
                  cd /catkin_ws/ && \
                  catkin_make"

COPY ./ros_entrypoint.sh /ros_entrypoint.sh
