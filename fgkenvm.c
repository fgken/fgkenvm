
void main(void)
{
	__asm__(".intel_syntax noprefix");
	__asm__("mov ah, 0x0e");
	__asm__("mov al, 0x42");
	__asm__("mov bx, 15");
	__asm__("int 0x10");

fin:
	goto fin;
}
