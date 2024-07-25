#include <stdio.h>
#include <stdlib.h>

int main() {
	int *p;

	p = malloc(sizeof(int));

	if (p == NULL) {
	    printf("Bad malloc error\n");
	    exit(1);   // exit the program and indicate error
	}
	*p = 6;

    // int *p;
    // // recasting malloc's default return type from 'void *' to 'int *'
    // p = malloc(sizeof(int));  // allocate heap memory for storing an int
    // p = (int *) malloc(sizeof(int));

    // if (p != NULL) {
    //     *p = 6;   // the heap memory p points to gets the value 6
    //     printf("%d", *p);
    // }
    //
    // When a program no longer needs the heap memory it dynamically
    // al­located with malloc, it should explicitly deallocate the
    // memory by calling the free function
    free(p);
    p = NULL;
}
