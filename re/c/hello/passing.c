// How does a compiler see a function in terms of types?
// C, return value type and, parameter count and types?

// - objects, types, functions, pointers, addresses 
// - object pointers, function pointers

#include <stdio.h>
#include <stdlib.h>

void swap(int *, int *);

int main() {
    int a = 21;
    int b = 12;
    swap(&a,&b);
    printf("main: a = %d, b = %d\n", a,b);
    return EXIT_SUCCESS;
}


// call-by-value, pass-by-value, pass-by-reference
void swap(int *pa, int *pb) {
    int t = *pa;
    *pa = *pb;
    *pb = t; 
    // printf("swap: a = %d, b = %d\n", *a,*b);
}