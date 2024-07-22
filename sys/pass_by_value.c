#include <stdio.h>
// Modifying arrays in a function changes the original arrays
// The call in main to the test function is passed the argument arr,
// whose value is the base address of the arr array in memory.
// The parameter a in the test function gets a copy of this base address value.
void test(int a[], int size) {
    if (size > 3) {
    	a[3] = 8;
    }
    size = 2; // changing parameter does NOT change argument
}

int main() {

    int arr[5], n = 5, i;

    for (i = 0; i < n; i++) {
        arr[i] = i;
    }

    printf("%d %d \n", arr[3], n);  // prints: 3 5

    test(arr, n);
    printf("%d %d \n", arr[2], n);  // prints: 8 5
    printf("%d %d \n", arr[3], n);  // prints: 8 5
    printf("%d %d \n", arr[4], n);  // prints: 8 5
		return 0;
}
