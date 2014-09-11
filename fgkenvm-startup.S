BOTPAK		EQU		0x00280000
DSKCAC		EQU		0x00100000
DSKCAC0		EQU		0x00008000

; BOOT_INFO
CYLS		EQU		0x0ff0
LEDS		EQU		0x0ff1
VMODE		EQU		0x0ff2
SCRNX		EQU		0x0ff3
SCRNY		EQU		0x0ff4
VRAM		EQU		0x0ff5

org		0x8200

	; print welcome message
	mov		SI, welcomemsg
putloop:
	mov		AL, [SI]
	add		SI, 1
	cmp		AL, 0
	je		putloop_fin
	mov		AH, 0x0e
	mov		BX, 15
	int		0x10
	cmp		AL, 0x0a
	jne		putloop

	; set cursor position to row head
	mov		AH, 0x03
	mov		BH, 0
	int		0x10			; get cursor position etc.
	mov		DL, 0			; Column = 0
	mov		AH, 0x02
	int		0x10
	jmp		putloop

putloop_fin:

	jmp		bootpack

	alignb	16

GDT0:
	resb	8			; NULL selector
	dw		0xffff, 0x0000, 0x9200, 0x00cf
	dw		0xffff, 0x0000, 0x9a28, 0x0047
	dw		0

GDTR0:
	dw		8*3-1
	dd		GDT0

	alignb	16

welcomemsg:
db		0x0a
db		"===========================", 0x0a
db		"=== Welcome to FgkenVM! ===", 0x0a
db		"===========================", 0x0a
db		0x0a
db		0

bootpack:
