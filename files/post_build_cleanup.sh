#!/bin/sh
TARGET=$1
mkdir -p $TARGET/etc/init.d/manual
mv $TARGET/etc/init.d/S01logging $TARGET/etc/init.d/manual/
mv $TARGET/etc/init.d/sixad $TARGET/etc/init.d/manual/

cp -f $TARGET/usr/share/terminfo/x/xterm-color $TARGET/usr/share/terminfo/x/xterm-256color

echo "The working dir is: $TARGET"
echo "Press [Enter]"
read dev

exit 0

