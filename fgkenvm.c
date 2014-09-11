
void main(void)
{
	int i;

	for(i=0xa0000; i <= 0xaffff - 0xffff/2; i++){
		*(char *)i = 10;
	}
	for(; i <= 0xaffff; i++){
		*(char *)i = 15;
	}

fin:
	goto fin;
}
