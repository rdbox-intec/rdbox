# `Live ROS` Builder

![USB](./docs/usb_hand_memory.png)

Create a ROS LiveUSB using Docker and chroot.  
It is very easy to create.  
And does not pollute your working environment. (Using docker and chroot)  

**Hope for the best, prepare for the worst.**

## Get started
1. Requirement
   - Linux(Tested on Ubuntu 18.04.)
   - Docker
   - Join the operator to the docker group so that you can execute the docker command without using sudo.

   ```bash
   $ sudo gpasswd -a $USER docker
   $ sudo systemctl restart docker
   $ exit
   ```

2. Create ISO
   - RTI Connext requires license agreement (installed with ROS2)
      - Please check in advance. [RTI Software License Agreement \| Data Distribution Service \(DDS\) Community RTI Connext Users](https://community.rti.com/content/page/rti-software-license-agreement)

   - ROS1 (Melodic Morenia)
   ```bash
   $ make iso-ros1
   ```

   - ROS2 (Dashing Diademata)
   ```bash
   $ make iso-ros2
   ```

   - ROS1 & ROS2
   ```bash
   $ make iso-all
   ```


3. Make a bootable USB image  
   It is simple and easy, using `dd`.  
   <device> is the drive path of your USB memory (e.g. /dev/sdc)  
   You can check the device name with `sudo fdisk -l`.
   ```bash
   $ sudo dd if=live-ros.iso of=<device> status=progress oflag=sync
   ```

## Customize
If you want to install your own additional package, add the package name to `ListOfPackagesToInstall.txt`.
```bash
$ vi ListOfPackagesToInstall.txt
packageA
packageB
packageC
:
:
```

## Bibliography
[How to create a custom Ubuntu live from scratch \- ITNEXT](https://itnext.io/how-to-create-a-custom-ubuntu-live-from-scratch-dd3b3f213f81)