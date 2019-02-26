FROM rdbox/arm.ros:kinetic-ros-base_catkin-ws

RUN apt-get update && apt-get install -y \
        ros-kinetic-rosserial-python \
        ros-kinetic-tf \
        apt-transport-https \
        jq \
        curl && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubeadm kubectl kubelet && \
    rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/hls_lfcd_lds_driver.git && \
                  cd /catkin_ws/src/hls_lfcd_lds_driver && \
                  git checkout 1.0.0 && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
                  cd /catkin_ws/src/turtlebot3_msgs && \
                  git checkout 1.0.0 && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/ROBOTIS-GIT/turtlebot3.git && \
                  cd /catkin_ws/src/turtlebot3 && \
                  git checkout 1.1.0 && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_description && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_example && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_navigation && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_slam && \
                  rm -rf /catkin_ws/src/turtlebot3/turtlebot3_teleop && \
                  sed -i "/exec_depend/d" /catkin_ws/src/turtlebot3/turtlebot3/package.xml && \
                  sed -i "/exec_depend/d" /catkin_ws/src/turtlebot3/turtlebot3_bringup/package.xml && \
                  cd /catkin_ws/ && \
                  catkin_make"

COPY execute_kubectl-apply_on_each_master_for_tb3.bash /usr/local/bin/
COPY execute_kubectl-delete_on_each_master_for_tb3.bash /usr/local/bin/
