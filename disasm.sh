#!/bin/sh
objdump -D -b binary -m i8086 -M intel $1
