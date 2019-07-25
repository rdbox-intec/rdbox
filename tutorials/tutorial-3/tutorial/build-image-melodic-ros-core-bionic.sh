#!/bin/bash

cd ~
mkdir ros-core
cd ros-core
wget https://raw.githubusercontent.com/osrf/docker_images/master/ros/melodic/ubuntu/bionic/ros-core/Dockerfile
sed -i '/^FROM/c FROM multiarch/ubuntu-core:armhf-bionic' Dockerfile
wget https://raw.githubusercontent.com/osrf/docker_images/master/ros/melodic/ubuntu/bionic/ros-core/ros_entrypoint.sh
chmod +x ros_entrypoint.sh
sudo docker build -t rdbox/ros:melodic-ros-core-bionic -f ./Dockerfile .