FROM rdbox/arm.ros:kinetic-ros-base_catkin-ws

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  catkin_create_pkg topic_tools_launch std_msgs && \
                  mkdir -p /catkin_ws/src/topic_tools_launch/launch"

COPY ./relay.launch /catkin_ws/src/topic_tools_launch/launch/relay.launch
COPY ./transform.launch /catkin_ws/src/topic_tools_launch/launch/transform.launch

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/ && \
                  catkin_make"

