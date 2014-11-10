#!/bin/sh
#nasm $1 -o ${1%.*}.bin
gcc -C -march=i386 -masm=intel -nostdlib bootloader.s
