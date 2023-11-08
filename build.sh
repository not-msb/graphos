#!/bin/sh

set -e

if [ "$1" == "clear" ]
then
    rm -f kernel
    exit
fi

fasm boot.asm kernel

if [ "$1" == "sim" ]
then
    qemu-system-i386 -drive format=raw,file=kernel
fi
