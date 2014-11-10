OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(fgkenvm_start)

SECTIONS
{
	. = 0x4000;
	.bss : { *(.bss) }
	. = 0x7C00;
	.text : { *(.text) }
	. = 0xA000;
	.data : { *(.data) }
}
