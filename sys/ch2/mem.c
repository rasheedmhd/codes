#include <stdio.h>

// function prototypes
int max(int n1, int n2);
int change(int amt);

int g_x;

int main() {

	int x, result;

	printf("Enter a value: ");
	scanf("%d", &x);

	g_x = 10;

	result = max(g_x, x);
	printf("%d is the largest of %d and %d\n", result, g_x, x);

	result = change(10);
	printf("g_x's value was %d and now is %d\n", result, g_x);

	return 0;

}

int max(int n1, int n2) {  /* function with two parameters */
    int val;    /* local variable */
    val = n1;
    if ( n2 > n1 ) {
    	val = n2;
    }
    return val;
}

int change(int amt) {
    int val;
    /* global variables can be accessed in any function */
    val = g_x;
    g_x += amt;
    return val;
}
