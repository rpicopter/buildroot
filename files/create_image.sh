#!/bin/sh

DISKSIZE=87040000 #bytes - should be divideable by sector size (512) 
FS1_SIZE=8704000 #bytes - should be divideable by sector size (512)


BR_IMAGE_DIR=$1
MY_PATH="`dirname \"$0\"`"
SECTORSIZE=512
DISKSIZE_SECTORS=$(( $DISKSIZE / $SECTORSIZE ));
FS1_SIZE_SECTORS=$(( $FS1_SIZE / $SECTORSIZE ));
FS1_START_SECTOR=2048
FS2_START_SECTOR=$(( $FS1_START_SECTOR + $FS1_SIZE_SECTORS + 1 ));

rm rpicopter.img
echo "Preparing image..."
dd if=/dev/zero of=rpicopter.img count=$DISKSIZE_SECTORS
echo "- stage 1/6" 

(echo n; echo p; echo 1; echo ; echo +$FS1_SIZE_SECTORS; echo t; echo b; echo n; echo p; echo ; echo ; echo ; echo t; echo 2; echo 83; echo w) | fdisk -u rpicopter.img > /dev/null 
echo "- stage 2/6" 

sudo losetup --offset $(( $SECTORSIZE * $FS1_START_SECTOR)) --sizelimit $FS1_SIZE /dev/loop0 rpicopter.img
sudo mkdosfs /dev/loop0
sudo losetup -d /dev/loop0
sudo losetup --offset $(( $SECTORSIZE * $FS2_START_SECTOR ))  /dev/loop0 rpicopter.img
sudo mkfs.ext2 /dev/loop0
sudo losetup -d /dev/loop0
echo "- stage 3/6"

mkdir -p tmp/fs1 
mkdir -p tmp/fs2

sudo mount -o loop,rw,offset=$(( $FS1_START_SECTOR * $SECTORSIZE )) rpicopter.img tmp/fs1
sudo mount -o loop,rw,offset=$(( $FS2_START_SECTOR * $SECTORSIZE )) rpicopter.img tmp/fs2
echo "- stage 4/6"

sudo cp $BR_IMAGE_DIR/rpi-firmware/* tmp/fs1
sudo cp $MY_PATH/configs/rpi_boot_config.txt tmp/fs1/config.txt
sudo cp $MY_PATH/configs/rpi_boot_cmdline.txt tmp/fs1/cmdline.txt
sudo cp $BR_IMAGE_DIR/zImage tmp/fs1
sudo tar xf $BR_IMAGE_DIR/rootfs.tar -C tmp/fs2

echo "- stage 5/6"
sudo umount tmp/fs1
sudo umount tmp/fs2
rm -rdf tmp
sync;sync;

echo "- stage 6/6"
echo "Your SD card image is called rpicopter.img and located in the root of your buildroot directory."

echo -n "Enter the device to write the image to, i.e./dev/null (CTRL+C to cancel): "
read dev 

if test x$dev = x; then
   dev=/dev/null
fi

for f in $dev*; do 
echo -n "Unmounting device $f ... "
sudo umount $f
echo "Done." 
done

echo -n "Writing image to the device... "
dd if=rpicopter.img of=$dev bs=4M
sync;sync
echo "DONE. You can now safely remove your SD card and place it in your Raspberry Pi."
echo "Enjoy!"
echo

