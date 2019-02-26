FROM rdbox/amd64.ros:kinetic-ros-base_catkin-ws

RUN apt-get update && apt-get install -y \
     ros-kinetic-joy ros-kinetic-teleop-twist-joy ros-kinetic-teleop-twist-keyboard ros-kinetic-laser-proc ros-kinetic-rgbd-launch ros-kinetic-depthimage-to-laserscan ros-kinetic-rosserial-arduino ros-kinetic-rosserial-python ros-kinetic-rosserial-server ros-kinetic-rosserial-client ros-kinetic-rosserial-msgs ros-kinetic-amcl ros-kinetic-map-server ros-kinetic-move-base ros-kinetic-urdf ros-kinetic-xacro ros-kinetic-compressed-image-transport ros-kinetic-rqt-image-view ros-kinetic-gmapping ros-kinetic-navigation ros-kinetic-interactive-markers ros-kinetic-robot-state-publisher && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
                  cd /catkin_ws/src/turtlebot3_msgs && \
                  git checkout 1.0.0 && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3.git && \
                  cd /catkin_ws/src/turtlebot3 && \
                  git checkout 1.1.0 && \
                  cd /catkin_ws/ && \
                  catkin_make"
