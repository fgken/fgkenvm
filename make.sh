#!/bin/sh
./compile.sh bootloader.S
./compile.sh fgkenvm-startup.S
./compile-c.sh fgkenvm.c
cat bootloader.bin fgkenvm-startup.bin fgkenvm.bin > fgkenvm-floppy.img
