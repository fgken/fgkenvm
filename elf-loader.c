#include <stdio.h>
#include <sys/types.h>
//#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "elf.h"

void mem_dump(unsigned char *data, int size)
{
	int i=0;
	
	for(i=0; i<size; i++){
		printf("%.2x ", data[i]);
	}
}

int main(int argc, char *argv[])
{
	if(argc <= 1) return;

	char *filename = argv[1];
	printf("open file: %s\n", filename);

	int fd = open(argv[1], O_RDONLY);
	if(fd != -1){
		struct stat fileinfo;
		char *data;
		stat(filename, &fileinfo);
		data = mmap((caddr_t)0, fileinfo.st_size, PROT_READ, MAP_PRIVATE, fd, 0);

		if(data != MAP_FAILED){
			mem_dump(data, fileinfo.st_size);
			munmap(data, fileinfo.st_size);
		}
		close(fd);
	}
	else{
		printf("Can't open file\n");
	}
}
