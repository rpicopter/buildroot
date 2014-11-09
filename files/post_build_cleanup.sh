#!/bin/sh
TARGET=$1
mkdir -p $TARGET/etc/init.d/manual
mv $TARGET/etc/init.d/S60nfs $TARGET/etc/init.d/manual/
mv $TARGET/etc/init.d/S01logging $TARGET/etc/init.d/manual/
mv $TARGET/etc/init.d/S13portmap $TARGET/etc/init.d/manual/
mv $TARGET/etc/init.d/sixad $TARGET/etc/init.d/manual/

exit 0

