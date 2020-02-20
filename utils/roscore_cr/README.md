# roscore_cr
Remove Single Point Of Failer of the roscore.

[![Remove Single Point Of Failer of the ROS](http://img.youtube.com/vi/t3fip33nGts/0.jpg)](http://www.youtube.com/watch?v=t3fip33nGts)
[Remove Single Point Of Failer of the ROS](https://youtu.be/t3fip33nGts)

[Remove single point of failer of the ros(SlideShare)](https://www.slideshare.net/tatsuyafukuta1/remove-single-point-of-failer-of-the-ros)

## Requirement
### Host
* VirtualBox + Vagrant  
[Getting Started \- Vagrant by HashiCorp](https://www.vagrantup.com/intro/getting-started/index.html)
### Guest
* xenial(Ubuntu 16.04)
   - Ubuntu 16.04.4 (Operation checked Linux ubuntu-xenial 4.13.0-43-generic #48~16.04.1-Ubuntu SMP Thu May 17 12:56:46 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux)
* bionic(Ubuntu 18.04)
   - Linux ubuntu-bionic 4.15.0-23-generic #25-Ubuntu SMP Wed May 23 18:02:16 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
* Docker 17.09.1~ce-0~ubuntu

## Setup on virtualbox
* Caution! The operation differs with kinetic and melodic.
### xenial(Ubuntu16.04,ROS-kinetic)
```bash
git clone https://github.com/fudekun/roscore_cr.git
cd roscore_cr/xenial-kinetic
vagrant up
```

### bionic(Ubuntu18.04,ROS-melodic)
```bash
git clone https://github.com/fudekun/roscore_cr.git
cd roscore_cr/bionic-melodic
vagrant up
```

* You are prompted to select the interface to bridge with the guest OS. You choose the right one.
```
==> default: Available bridged network interfaces:
1) en0: Wi-Fi (AirPort)
2) p2p0
3) awdl0
4) en1: Thunderbolt 1
5) en2: Thunderbolt 2
6) en3: Thunderbolt 3
7) en4: Thunderbolt 4
8) bridge0
9) en5: USB Ethernet(?)
==> default: When choosing an interface, it is usually the one that is
==> default: being used to connect to the internet.
    default: Which interface should the network bridge to? 
```

  - It is also possible to specify a network interface. (Vagrantfile)
  ```
  config.vm.network :public_network, bridge: "en0: Wi-Fi (AirPort)"
  ```

### Only xenial(Ubuntu16.04,ROS-kinetic)
* Caution! The operation differs with kinetic and melodic.
* Need Reboot(the reason is to update the kernel.)
```bash
vagrant reload
```

### (Option)Check IP address of guest OS
```bash
vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null
```

## Run(Only First)
```bash
# Host
vagrant ssh
# Guest
sudo groupadd docker
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
exit
```

## Run
* Caution! The operation differs with kinetic and melodic.
* If you use a different ROS distribution, please change the environment variable "ROS_DISTRO".
* It takes time to download the image at the first startup.
### xenial(Ubuntu16.04,ROS-kinetic)
```bash
# Host
vagrant ssh
# Guest
export ROS_DISTRO=kinetic
~/roscore_cr/roscore_cr {option of roscore}
```

### bionic(Ubuntu18.04,ROS-melodic)
```bash
# Host
vagrant ssh
# Guest
export ROS_DISTRO=melodic
~/roscore_cr/roscore_cr {option of roscore}
```


---
## Setup detail(Ubuntu16.04,kinetic)
### Kernel
```bash
sudo apt-get update
sudo apt-get install -y linux-image-extra-4.13.0-43-generic
# or
sudo apt-get install -y linux-generic-hwe-16.04 
```

### Docker
* Supplement: Docker's Checkpoint & Restore function is experimentally implemented.
  - [docker checkpoint \| Docker Documentation](https://docs.docker.com/engine/reference/commandline/checkpoint/)
* Docker must install Version `17.09.1~ce-0~ubuntu`.
  - I confirmed that improving fault tolerance of roscore using Docker's CR function does not work except `17.09.1~ce-0~ubuntu`. (Confirmed on June 10, 2018)

#### install
```bash
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get update
sudo apt-get install -y docker-ce=17.09.1~ce-0~ubuntu
```

#### setting
* Enable experimentally implemented.
```bash
echo '{
  "experimental": true
}' | sudo tee /etc/docker/daemon.json

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker
```


### CRIU
#### install
```bash
sudo apt-get install -y \
  libc6 \
  libnet1 \
  libnl-3-200 \
  libprotobuf-c1 \
  python \
  python-ipaddr \
  python-protobuf \
  iproute2
wget http://lug.mtu.edu/ubuntu/pool/universe/c/criu/criu_3.6-2_amd64.deb
sudo dpkg -i criu_3.6-2_amd64.deb
```
