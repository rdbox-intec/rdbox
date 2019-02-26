#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y python ansible lsb-release \
                    avahi-daemon avahi-utils \
                    git curl vim ipcalc

#
