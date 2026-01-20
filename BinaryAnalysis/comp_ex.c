#include <stdio.h>

#define FORMAT_STRING "%s"
#define MESSAGE "Hello, World!\n"

int
main(int argc, char *argv[]) {
	printf(FORMAT_STRING, MESSAGE);
	return 0;
};
