#!/bin/bash
set -ex

if [ ! -f /.dockerenv ]; then
  echo "ERROR: script works only in a Docker container!"
  exit 1
fi

IMAGE_VERSION=${VERSION:="18.04"}

BUILD_RESULT_PATH="/workspace"

BUILD_PATH="/build"
rm -rf ${BUILD_PATH}
mkdir ${BUILD_PATH}
mkdir -p ${BUILD_PATH}/live-ubuntu

debootstrap \
    --arch=amd64 \
    --variant=minbase \
    --include="wget gnupg lsb-release" \
    bionic \
    ${BUILD_PATH}/live-ubuntu/chroot \
    http://ftp.riken.go.jp/Linux/ubuntu/

cp -rf ${BUILD_RESULT_PATH}/ListOfPackagesToInstall.txt ${BUILD_PATH}/live-ubuntu/chroot/tmp/ListOfPackagesToInstall.txt

mount --bind /dev ${BUILD_PATH}/live-ubuntu/chroot/dev
mount --bind /run ${BUILD_PATH}/live-ubuntu/chroot/run

ROS_TARGET=$1 chroot ${BUILD_PATH}/live-ubuntu/chroot /bin/bash < /builder/chroot-script.sh

umount ${BUILD_PATH}/live-ubuntu/chroot/dev
umount ${BUILD_PATH}/live-ubuntu/chroot/run

# Create the CD image directory and populate it
cd ${BUILD_PATH}/live-ubuntu/
mkdir -p image/{casper,isolinux,install}
cp chroot/boot/vmlinuz-**-**-generic image/casper/vmlinuz
cp chroot/boot/initrd.img-**-**-generic image/casper/initrd
## Copy memtest86+ binary (BIOS)
cp chroot/boot/memtest86+.bin image/install/memtest86+
## Download and extract memtest86 binary (UEFI)
wget --progress=dot https://www.memtest86.com/downloads/memtest86-usb.zip -O image/install/memtest86-usb.zip
unzip -p image/install/memtest86-usb.zip memtest86-usb.img > image/install/memtest86
rm image/install/memtest86-usb.zip

# For Grub
touch image/ubuntu
cat <<EOF > image/isolinux/grub.cfg
search --set=root --file /ubuntu

insmod all_video

set default="0"
set timeout=30

menuentry "Try Ubuntu without installing" {
   linux /casper/vmlinuz boot=casper quiet splash ---
   initrd /casper/initrd
}

menuentry "Install Ubuntu" {
   linux /casper/vmlinuz boot=casper only-ubiquity quiet splash ---
   initrd /casper/initrd
}

menuentry "Check disc for defects" {
   linux /casper/vmlinuz boot=casper integrity-check quiet splash ---
   initrd /casper/initrd
}

menuentry "Test memory Memtest86+ (BIOS)" {
   linux16 /install/memtest86+
}

menuentry "Test memory Memtest86 (UEFI, long load time)" {
   insmod part_gpt
   insmod search_fs_uuid
   insmod chain
   loopback loop /install/memtest86
   chainloader (loop,gpt1)/efi/boot/BOOTX64.efi
}
EOF
chroot chroot dpkg-query -W --showformat='${Package} ${Version}\n' | tee image/casper/filesystem.manifest
cp -v image/casper/filesystem.manifest image/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' image/casper/filesystem.manifest-desktop
sed -i '/casper/d' image/casper/filesystem.manifest-desktop
sed -i '/discover/d' image/casper/filesystem.manifest-desktop
sed -i '/laptop-detect/d' image/casper/filesystem.manifest-desktop
sed -i '/os-prober/d' image/casper/filesystem.manifest-desktop

# Compress the chroot
mksquashfs chroot image/casper/filesystem.squashfs
printf $(du -sx --block-size=1 chroot | cut -f1) > image/casper/filesystem.size

# Create diskdefines
cat <<EOF > image/README.diskdefines
#define DISKNAME  Ubuntu from scratch
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  amd64
#define ARCHamd64  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1
EOF

# Create ISO Image for a LiveCD (BIOS + UEFI)
cd ${BUILD_PATH}/live-ubuntu/image
grub-mkstandalone \
   --format=x86_64-efi \
   --output=isolinux/bootx64.efi \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"

(
  cd isolinux && \
  dd if=/dev/zero of=efiboot.img bs=1M count=10 && \
  mkfs.vfat efiboot.img && \
  mmd -i efiboot.img efi efi/boot && \
  mcopy -i efiboot.img ./bootx64.efi ::efi/boot/
)

cd ${BUILD_PATH}/live-ubuntu/image
grub-mkstandalone \
   --format=i386-pc \
   --output=isolinux/core.img \
   --install-modules="linux16 linux normal iso9660 biosdisk memdisk search tar ls" \
   --modules="linux16 linux normal iso9660 biosdisk search" \
   --locales="" \
   --fonts="" \
   "boot/grub/grub.cfg=isolinux/grub.cfg"

cat /usr/lib/grub/i386-pc/cdboot.img isolinux/core.img > isolinux/bios.img

/bin/bash -c "(find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)"

xorriso \
   -as mkisofs \
   -iso-level 3 \
   -full-iso9660-filenames \
   -volid "Live ROS" \
   -eltorito-boot boot/grub/bios.img \
   -no-emul-boot \
   -boot-load-size 4 \
   -boot-info-table \
   --eltorito-catalog boot/grub/boot.cat \
   --grub2-boot-info \
   --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
   -eltorito-alt-boot \
   -e EFI/efiboot.img \
   -no-emul-boot \
   -append_partition 2 0xef isolinux/efiboot.img \
   -output "${BUILD_RESULT_PATH}/live-ros.iso" \
   -graft-points \
      "." \
      /boot/grub/bios.img=isolinux/bios.img \
      /EFI/efiboot.img=isolinux/efiboot.img

