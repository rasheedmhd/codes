#include <string.h>
#include <stdio.h>

struct student {
    char name[64];
    int age;
    float gpa;
    int grad_yr;
};

struct student student1, student2;
//to the C compiler, fields are simply storage lo­ cations or offsets
// from the start of the struct variable’s memory. For example,
// based on the definition of a struct studentT, the compiler knows
// that to ac­ cess the field named gpa, it must skip past an array
//  of 64 characters (name) and one integer (age).

int main() {
	// The 'name' field is an array of characters, so we can use the 'strcpy'
	// string library function to fill in the array with a string value.
	strcpy(student1.name, "Kwame Salter");
	// The 'age' field is an integer.
	student1.age = 18 + 2;
	// The 'gpa' field is a float.
	student1.gpa = 3.5;
	// The 'grad_yr' field is an int
	student1.grad_yr = 2020;

	student2.grad_yr = student1.grad_yr;

	student2 = student1;

	strcpy(student2.name, "Frances Allen");

     /* Note: printf doesn't have a format placeholder for printing a
     * struct studentT (a type we defined).  Instead, we'll need to
     * individually pass each field to printf. */
    printf("name: %s age: %d gpa: %g, year: %d\n", student1.name, student1.age, student1.gpa, student1.grad_yr);

    /* Print the fields of student2. */
    printf("name: %s age: %d gpa: %g, year: %d\n", student2.name, student2.age, student2.gpa, student2.grad_yr);

	// Note: the '%lu' format placeholder specifies an unsigned long value.
    printf("number of bytes in student struct: %lu\n", sizeof(struct student));
	return 0;

}
