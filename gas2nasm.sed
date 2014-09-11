#!/bin/sed -f

s/PTR//g;
s/%//g;
s/\.\(L[0-9]*\)/\1/;
s/\.text/section text/;
s/\.globl/global/;
s/\.section\t\.rodata.*/section\trodata/;
/\.\(size\|file\|ident\|type\|align\|intel_syntax\)/s/^/;/;
/\.\(section\)/s/^/;/;
s/\.long/dd/
s/st(\([0-9]\))/st\1/g;
s/\([ ,\t]\{1,2\}\)st\([^0-9]\|$\)/\1st0\2/g
s/^#/;#/g
