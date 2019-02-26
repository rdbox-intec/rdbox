FROM rdbox/arm.turtlebot3_robot_side_bringup:kinetic_1.0.0

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  catkin_create_pkg launch_rostopic std_msgs && \
                  mkdir -p /catkin_ws/src/launch_rostopic/launch"

COPY pub_latch.launch /catkin_ws/src/launch_rostopic/launch/pub_latch.launch

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/ && \
                  catkin_make"

