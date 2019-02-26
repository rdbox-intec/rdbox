FROM rdbox/arm.ros:kinetic-ros-base_catkin-ws

RUN apt-get update && apt-get install -y \
    ros-kinetic-rosserial-python ros-kinetic-tf \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/hls_lfcd_lds_driver.git && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
                  cd /catkin_ws/src/turtlebot3_msgs && \
                  git checkout 0.1.3 && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3.git && \
                  cd /catkin_ws/src/turtlebot3 && \
                  git checkout 0.1.3 && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_description && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_fake && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_navigation && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_gazebo && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_slam && \
                  sed -i "/run_depend/d" /catkin_ws/src/turtlebot3/turtlebot3/package.xml && \
                  sed -i "/run_depend/d" /catkin_ws/src/turtlebot3/turtlebot3_bringup/package.xml && \
                  cd /catkin_ws/ && \
                  catkin_make"

