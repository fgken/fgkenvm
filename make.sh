#!/bin/sh
as $1 -o asm.elf
objcopy -O binary asm.elf asm.bin
