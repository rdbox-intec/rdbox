#!/bin/bash
set -ex

mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C

echo "live-ros-builder" > /etc/hostname

cat <<EOF > /etc/apt/sources.list
deb http://ftp.riken.go.jp/Linux/ubuntu/ bionic main restricted universe multiverse 
deb-src http://ftp.riken.go.jp/Linux/ubuntu/ bionic main restricted universe multiverse
deb http://ftp.riken.go.jp/Linux/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://ftp.riken.go.jp/Linux/ubuntu/ bionic-security main restricted universe multiverse
deb http://ftp.riken.go.jp/Linux/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://ftp.riken.go.jp/Linux/ubuntu/ bionic-updates main restricted universe multiverse    
EOF


apt-get update

apt-get install -y systemd-sysv

dbus-uuidgen > /etc/machine-id
ln -fs /etc/machine-id /var/lib/dbus/machine-id

dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

# Install packages needed for Live System
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ubuntu-standard \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    network-manager \
    resolvconf \
    net-tools \
    wireless-tools \
    wpagui \
    locales \
    sudo \
    linux-generic

# Graphical installer
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ubiquity \
    ubiquity-casper \
    ubiquity-frontend-gtk \
    ubiquity-slideshow-ubuntu \
    ubiquity-ubuntu-artwork

# Install window manager
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    plymouth-theme-ubuntu-logo \
    ubuntu-gnome-desktop \
    ubuntu-gnome-wallpapers

# Install ROS
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' \
    --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt-get update
apt-get install -y ros-melodic-desktop-full
apt-get install -y python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential

# Install user define apps
DEBIAN_FRONTEND=noninteractive apt-get install -y $(cat /tmp/ListOfPackagesToInstall.txt)

# Clean up
truncate -s 0 /etc/machine-id

rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

apt-get clean
rm -rf /tmp/* ~/.bash_history
umount /proc
umount /sys
umount /dev/pts
export HISTSIZE=0