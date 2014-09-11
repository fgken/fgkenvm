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

; set video mode
	mov		AL, 0x13		; VGA, 320*200*8bit color
	mov		AH, 0x00
	int		0x10
	mov		BYTE [VMODE], 8
	mov		WORD [SCRNX], 320
	mov		WORD [SCRNY], 200
	mov		DWORD [VRAM], 0x000a0000

; get status of keyboard's LED
	mov		AH, 0x02
	int		0x16			; keyboard BIOS
	mov		[LEDS], AL

; disable PIC interrupts
	mov		AL, 0xff
	out		0x21, AL
	nop
	out		0xa1, AL

	cli						; disable external interrupts

; set A20GATE to access memory address over 1MB
	call	waitkbdout
	mov		AL, 0xd1
	out		0x64, AL
	call	waitkbdout
	mov		AL, 0xdf
	out		0x60, AL
	call	waitkbdout


; transition to protected mode
	LGDT	[GDTR0]			; set temporary GDT
	mov		EAX, CR0
	and		EAX, 0x7fffffff	; inhibit paging
	or		EAX, 0x00000001	; for transition to protected mode
	mov		CR0, EAX
pipelineflush:
	mov		AX, 1*8			; segment permitted read/write
	mov		DS, AX
	mov		ES, AX
	mov		FS, AX
	mov		GS, AX
	mov		SS, AX

;; copy bootpack
;	mov		ESI, bootpack	; from
;	mov		EDI, BOTPAK		; to
;	mov		ECX, 512*1024/4
;	call	memcopy
;
;; boot bootpack
;	mov		EBX, BOTPAK
;	mov		ECX, [EBX+16]
;	add		ECX, 3
;	shr		ECX, 2
;	jz		skip
;	mov		ESI, [EBX+20]
;	add		ESI, EBX
;	mov		EDI, [EBX+12]
;	call	memcopy
;skip:
;	mov		ESP, [EBX+12]
;	jmp		DWORD 2*8:0x0000001b

	jmp		bootpack

waitkbdout:
	in		AL, 0x64
	and		AL, 0x02
	jnz		waitkbdout
	ret

memcopy:
	mov		EAX, [ESI]
	add		ESI, 4
	mov		[EDI], EAX
	add		EDI, 4
	sub		ECX, 1
	jnz		memcopy
	ret

welcomemsg:
db		0x0a
db		"===========================", 0x0a
db		"=== Welcome to FgkenVM! ===", 0x0a
db		"===========================", 0x0a
db		0x0a
db		0

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

bootpack:
