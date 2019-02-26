FROM rdbox/arm.ros:kinetic-perception_catkin-ws

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ubuntu-raspi2/ppa -y \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -o Dpkg::Options::="--force-overwrite" -y \
    libraspberrypi0 \
    libraspberrypi-dev

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd /catkin_ws/src && \
                  git clone https://github.com/UbiquityRobotics/raspicam_node.git && \
                  echo 'yaml https://raw.githubusercontent.com/UbiquityRobotics/rosdep/master/raspberry-pi.yaml' > /etc/ros/rosdep/sources.list.d/30-ubiquity.list && \
                  rosdep update && \
                  cd /catkin_ws/ && \
                  rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y && \
                  catkin_make && \
                  rm -rf /var/lib/apt/lists/*"

