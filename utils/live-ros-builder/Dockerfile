FROM ubuntu:bionic

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    binutils \
    debootstrap \
    squashfs-tools \
    xorriso \
    grub-pc-bin \
    grub-efi-amd64-bin \
    unzip \
    sudo \
    dosfstools \
    mtools && \
    rm -rf /var/lib/apt/lists/*

COPY builder/ /builder/

CMD /builder/build.sh
