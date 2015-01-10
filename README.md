This repository contains all necessary things needed to build an AvrMiniCopter image using buildroot.

####CHANGELOG:

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
- Download & extract official buildroot 
- Patch it using files in files/buildroot_patches folder
- Copy files/configs/buildroot_config into your buildroot folder and rename it to .config
- Verify .config (or make menuconfig):
	- global patch folder (BR2_GLOBAL_PATCH_DIR) - files/br_global_patches
	- default kernel config (BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE) - files/configs/kernel_config
	- NOTE: default kernel config path needs to be a fully qualified path
	- post image create scripts
		- BR2_ROOTFS_POST_BUILD_SCRIPT - files/post_build_cleanup.sh
		- BR2_ROOTFS_POST_IMAGE_SCRIPT - files/create_image.sh
- issue "make"
