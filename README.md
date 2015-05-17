This repository contains all necessary things needed to build an AvrMiniCopter image using buildroot.

####CHANGELOG:

**17 May 2015**
- moving to buildroot-2015.02
- syncing configs

**10 Jan 2015**
- adding rpcbind
- testing

**10 Dec 2014**
- Using Buildroot-2014.11
- adding ffmpeg, gstreamer1, janus-gateway, raspimjpeg

**16 Oct 2014**
- updated kernel config to 3.29.29
- added SPIDEV and NFSD to kernel config


####INSTALLATION:
1) Download & extract official buildroot from http://buildroot.uclibc.org

2) Patch it using files in buildroot/files/buildroot_patches folder

	cd buildroot-XXXX.XX

	patch -p1 < ../buildroot/files/buildroot.patch

3) Copy buildroot config and name it .config

	cp ../buildroot/files/configs/buildroot_config ./.config

4) Verify config to ensure (just edit .config):

	- BR2_GLOBAL_PATCH_DIR points to rpicopter buildroot/files/br_global_patches

	- BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE points to rpicopter /....../buildroot/files/configs/kernel_config  (this needs to be a fully qualified path) 

	- BR2_ROOTFS_POST_BUILD_SCRIPT - buildroot/files/post_build_cleanup.sh

	- BR2_ROOTFS_POST_IMAGE_SCRIPT - buildroot/files/create_image.sh

5) Run "make"

This will download all sources and create rpicopter image.
