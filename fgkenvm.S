
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

	jmp		fin

	mov		AL, 0x13
	mov		AH, 0x00
	int		0x10

fin:
	hlt
	jmp		fin

welcomemsg:
db		0x0a
db		"===========================", 0x0a
db		"=== Welcome to FgkenVM! ===", 0x0a
db		"===========================", 0x0a
db		0x0a
db		0


