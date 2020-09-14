#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y python \
                    ansible \
                    lsb-release \
                    avahi-daemon \
                    avahi-utils \
                    git \
                    curl \
                    vim \
                    ipcalc \
                    ruby-dev \
                    build-essential

# For Ansible Spec
sudo gem install ansible_spec