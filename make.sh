#!/bin/sh
./compile.sh bootloader.S -o bootloader.bin
./compile.sh fgkenvm.S -o fgkenvm.bin
cat bootloader.bin fgkenvm.bin > fgkenvm-floppy.img
