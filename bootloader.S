CYLS	EQU		10

;BITS	16
ORG		0x7c00

JMP		entry
DB		0x90
DB		"fgkenvm "
DW		512
DB		1
DW		1
DB		2
DW		224
DW		2880
DB		0xf0
DW		9
DW		18
DW		2
DD		0
DD		2880
DB		0, 0, 0x29
DD		0xffffffff
DB		"FgkenVM IMG"
DB		"FAT12   "
RESB	18

entry:
MOV		ax, 0
MOV		ss, ax
MOV		sp, 0x7c00
MOV		ds, ax

; print boot message
MOV		si, bootmsg

putloop:
MOV		al, [si]
ADD		si, 1
CMP		al, 0
JE		putloop_fin
MOV		ah, 0x0e
MOV		bx, 15
INT		0x10
JMP		putloop

putloop_fin:

; read disk
MOV		ax, 0x0820
MOV		es, ax
MOV		ch, 0	; Cylinder 0
MOV		dh, 0	; Head 0
MOV		cl, 2	; Sector 2

readloop:
MOV		si, 0

retry:
mov		AH, 0x02
mov		AL, 1
mov		BX, 0
mov		DL, 0x00
int		0x13
jnc		next
; error occurred
add		SI, 1
cmp		SI, 5
jae		error
mov		AH, 0x00
mov		DH, 0x00
int		0x13
jmp		retry

next:
mov		AX, ES
add		AX, 0x0020
mov		ES, AX
add		CL, 1
cmp		CL, 18
jbe		readloop
mov		CL, 1
add		DH, 1
cmp		DH, 2
jb		readloop
mov		DH, 0
add		CH, 1
cmp		CH, CYLS
jb		readloop

; finish reading
mov		[0x0ff0], CH
jmp		0x8200

error:
mov		SI,errormsg

puterror:
MOV		al, [si]
ADD		si, 1
CMP		al, 0
JE		errorhlt
MOV		ah, 0x0e
MOV		bx, 15
INT		0x10
JMP		putloop

errorhlt:
hlt
jmp		errorhlt

bootmsg:
DB		0x0a
DB		"IPL: Now Loading..."
DB		0x0a,0x0a
DB		0

errormsg:
DB		0x0a, 0x0a
DB		"Error: can't read disk"
DB		0x0a, 0x0a
DB		0

TIMES	510-($-$$)	DB	0

DB		0x55, 0xaa
