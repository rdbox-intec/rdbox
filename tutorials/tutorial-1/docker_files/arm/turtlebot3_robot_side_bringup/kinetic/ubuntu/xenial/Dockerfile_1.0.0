FROM rdbox/arm.ros:kinetic-ros-base_catkin-ws

RUN apt-get update && apt-get install -y \
    ros-kinetic-rosserial-python ros-kinetic-tf \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/hls_lfcd_lds_driver.git && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3.git && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_description && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_example && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_navigation && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_slam && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_teleop && \
                  sed -i "/exec_depend/d" /catkin_ws/src/turtlebot3/turtlebot3/package.xml && \
                  sed -i "/exec_depend/d" /catkin_ws/src/turtlebot3/turtlebot3_bringup/package.xml && \
                  cd /catkin_ws/ && \
                  catkin_make"

