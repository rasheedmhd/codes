// 
// Enums
// 
enum week { monday, tuesday, wednesday, thursday, friday, saturday, sunday };
enum cardinal_points { north = 0, east = 90, south = 180, west = 270 };
enum months { january = 1, february, march, april, may, june, july, august, september, october, november, december };

// Enums with underlying types
enum a: unsigned long long { 
    a1 = 0xFFFFFFFFFFFFFFFFULL
};

//
//
// Floats 
// 
//
// Standard floating types
//
// float
// double
// long double


// Decimal floating types (C23)
//
// _Decimal32
// _Decimal64
// _Decimal128;
//
// decimal32
// decimal64
// decimal128;

// Complex floating types
//
//  float complex
//  double complex
// long double complex

//
// void
//
// void -> cannot hold any value.
// used when a function takes no parameters or returns no values
// void function() {}
// return_type function(void) {}
// However void * acts like a catch all pointer, meaning it can reference object


// Derived Types
// 
// Are constructed from other types,
// structure types         struct
// function types          void function() {}
// type definitions        typedef 
// array types             ar[8]
// pointers types          char *
// union types etc


// FUNCTIONS
int f(void);
int f2(); 
int *p();
int ij(int i, int j);
int n(int, int);
// Function type 
// <- func return type + parameter count & types 
// can be any complete[what?] type except array type

// Parts of a Function 
// Return Type: The type of the value that the functions returns after execution
// Function Declaration: 
// Function Prototype: Same as the function type. Communicates the return type, parameter count and types to the compiler.
// Function Definition:
// Function body: