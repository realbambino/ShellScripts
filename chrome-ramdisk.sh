#!/bin/bash

DISK=`/usr/bin/hdiutil attach -nomount ram://2097152`
/usr/sbin/diskutil erasevolume HFS+ "RAMDisk" $DISK
/bin/rm -rvf ~/Library/Caches/Google/Chrome/*
/bin/mkdir -pv /Volumes/RAMDisk/Google
/bin/ln -v -s /Volumes/RAMDisk/Google ~/Library/Caches/Google/Chrome/Default