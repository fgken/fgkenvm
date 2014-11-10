#!/bin/sh
#gcc -S -m32 -masm=intel -fno-asynchronous-unwind-tables -fno-builtin -fno-common -nostdinc -nostdlib -static $1
#./gas2nasm.sed ${1%.*}.s > ${1%.*}.nasm
#nasm ${1%.*}.nasm -o ${1%.*}.bin

gcc -T script.ld -fno-asynchronous-unwind-tables -fno-builtin -fno-common -nostdinc -nostdlib -march=x86-64 $1
objcopy -O binary -j .text a.out ${1%.*}.bin
