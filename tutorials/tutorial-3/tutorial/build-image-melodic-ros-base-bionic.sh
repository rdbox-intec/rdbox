#!/bin/bash

cd ~
mkdir ros-base
cd ros-base
wget https://raw.githubusercontent.com/osrf/docker_images/master/ros/melodic/ubuntu/bionic/ros-base/Dockerfile
sed -i '/^FROM/c FROM rdbox/ros:melodic-ros-core-bionic' Dockerfile
sudo docker build -t rdbox/ros:melodic-ros-base-bionic -f ./Dockerfile .