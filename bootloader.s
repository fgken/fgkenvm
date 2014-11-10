.text
#define AAA 1

start_mbr:
	// print boot message
	mov		$0, %ax
	mov		%ax, %ss
	mov		%ax, %ds
	mov		$0x7c00, %sp

	mov		bootmsg, %si

putloop:
	mov		0(%esi), %al
	add		$1, %si
	cmp		$0, %al
	je		putloop_fin
	mov		$0x0e, %ah
	mov		$15, %bx
	int		$0x10
	jmp		putloop

putloop_fin:
	jmp		putloop_fin



bootmsg:
	.asciz	"fgken IPL: Now Loading..."
.fill	500, 2, 0x55aa
.byte	0x55, 0xaa

