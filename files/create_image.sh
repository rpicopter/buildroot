#!/bin/sh

DISKSIZE=122880000 
#DISKSIZE=87040000 #bytes - should be divideable by sector size (512) 
FS1_SIZE=10240000 #bytes - should be divideable by sector size (512)


BR_IMAGE_DIR=$1
MY_PATH="`dirname \"$0\"`"
SECTORSIZE=512
DISKSIZE_SECTORS=$(( $DISKSIZE / $SECTORSIZE ));
FS1_SIZE_SECTORS=$(( $FS1_SIZE / $SECTORSIZE ));
FS1_START_SECTOR=2048
FS2_START_SECTOR=$(( $FS1_START_SECTOR + $FS1_SIZE_SECTORS + 1 ));
FS2_START_SECTOR=22528

rm rpicopter.img
echo "Preparing image..."
dd if=/dev/zero of=rpicopter.img count=$DISKSIZE_SECTORS
echo "- stage 1/6" 

(echo n; echo p; echo 1; echo ; echo "+$FS1_SIZE_SECTORS"; echo t; echo b; echo n; echo p; echo ; echo ; echo ; echo t; echo 2; echo 83; echo w) | fdisk -u rpicopter.img > /dev/null 
echo "- stage 2/6" 

sudo losetup --offset $(( $SECTORSIZE * $FS1_START_SECTOR)) --sizelimit $FS1_SIZE /dev/loop0 rpicopter.img
echo "Offset 1: $(( $SECTORSIZE * $FS1_START_SECTOR ))"
sudo mkdosfs /dev/loop0
sudo losetup -d /dev/loop0
sudo losetup --offset $(( $SECTORSIZE * $FS2_START_SECTOR ))  /dev/loop0 rpicopter.img
echo "Offset 2: $(( $SECTORSIZE * $FS2_START_SECTOR ))"
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
sudo cp $MY_PATH/configs/start.elf tmp/fs1/start.elf
sudo cp $MY_PATH/configs/fixup.dat tmp/fs1/fixup.dat
sudo cp $MY_PATH/configs/start_x.elf tmp/fs1/start_x.elf
sudo cp $MY_PATH/configs/fixup_x.dat tmp/fs1/fixup_x.dat
sudo cp $MY_PATH/configs/bootcode.bin tmp/fs1/bootcode.bin
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

confirm=y
if test x$dev = x/dev/sda; then
   confirm=n
   echo "Are you sure you want to write to: $dev [y/N]?"
   read confirm
fi
if test x$confirm != xy; then
   exit 0;
fi


for f in $dev?; do 
echo -n "Unmounting device $f ... "
sudo umount $f
echo "Done." 
done

echo -n "Writing image to the device... "
sudo dd if=rpicopter.img of=$dev bs=4M
sync;sync
echo "DONE. You can now safely remove your SD card and place it in your Raspberry Pi."
echo "Enjoy!"
echo
exit 0

