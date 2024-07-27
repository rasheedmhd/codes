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



    // Dynamically Allocated Arrays and Strings
    int *arr;
    char *c_arr;
    // allocate an array of 20 ints on the heap:
    arr = malloc(sizeof(int) * 20);
    // allocate an array of 10 chars on the heap:
    c_arr = malloc(sizeof(char) * 10);


    free(p);
    p = NULL;

    int i;
    int s_array[20];
    int *d_array;
    d_array = malloc(sizeof(int) * 20);
    if (d_array == NULL) {
        printf("Error: malloc failed\n");
        exit(1);
    }
    for (i=0; i < 20; i++) {
        s_array[i] = i;
        d_array[i] = i;
    }
    printf("%d %d \n", s_array[3], d_array[3]);  // prints 3 3

}
