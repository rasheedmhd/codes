
#include <stdio.h>

void print_array(int arr[], int size) {

	int i;
	for(i = 0; i < size; i++) {
		printf("%d\n", arr[i]);
	}
}

int main() {
	// int i, size = 0;

	// // declare array of 10 ints
	// int my_array[10];

	// // set the value of each array element
	// for(i = 0; i < 10; i++) {
	// 	my_array[i] = i;
	// 	size++;
	// }

  // set value at position 3 to 100
	// my_array[3] = 100;

 //  // print the number of array elements (Array length)
	// // printf("Array of %d items:\n", size);

	// // printing each element of the array
	// for(i = 0; i < 10; i++) {
	// 	// printf("%d\n", my_array[i]);
	// }

	// for(i = 0; size < 10; i++) {
	// 	printf("%d\n", arr[i]);
	// }
	// return  0;
	int  some[5], more[10], i;
	char name[7];
	name[0] = 's';
	name[1] = 't';
	name[2] = 'a';
	name[3] = 'r';
	name[4] = 'l';
	name[5] = 'e';
	name[6] = 't';

	printf("%s\n", name);

	for (i = 0; i < 5; i++) {  // initialize the first 5 elements of both arrays
	    some[i] = i * i;
	    more[i] = some[i];
	}
	for (i = 5; i < 10; i++) { // initialize the last 5 elements of "more" array
		more[i] = more[i-1] + more[i-2];
	}

	// print_array(some, 5);
	// print_array(more, 10);
 //  print_array(more, 8);

	return 0;

}
