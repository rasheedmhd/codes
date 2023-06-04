Numbers
Strings
Booleans
Runes and grapheme clusters
Symbols 


Numbers
    int
    double

Strings
    String
    
Booleans
    bool

Lists 
    List // alias arrays

Sets
    Set

Maps
    Maps

Runes
    Runes // often replaced by the characters API
    
Symbols
    Symbol

// The value null(Null)
null
Null

// Every variable in Dart refers to an object
// an object is an instance of a class
// Therefore you can you use constructors to initialize variables


// Some built-in types have their own constructors

// Other Types
Object // super class of all Dart classes except Null
Enum 
Future
Stream
Iterable
Never
dynamic // disable static checking
// Usually it is better to use
    Object
    Object? // possibility of holding a 
        Null



// Have special roles in class hierarchy
Object
Object?
Never
Null

// NUMBERS
int // < 64bits
double // double-precision floats -> IEEE 754

// num
num -> subtypes int and double
// num methods
abs();
ceil();
floor();

"dart:math" // more methods 

num x = 1 // can hold both int and double 

// SWITCHING FROM STRING INTO NUMBER AND VICE VERSA
// String -> int
int.parse("1");

// String -> double
double.parse("1.1");

// int -> String 
1.toString();

// double -> String
3.14159.toStringAsFixed(2)


// Literal numbers are compile-time constants
// Arithmetic expressions are compile-time constants
// as long as their operands are compile-time constants


// STRINGS
// Holds a sequence of UTF-16 code units

// String Interpolation
${expression}

// if expression is identifier
$

// String Concatenation
+

// Multi-line Commands
""""
This 
is 
a multi 
line
string
""""


'''
This 
is 
a multi 
line
string
'''

// String Interpolation 
r"This is a raw 
string
not even \n gets 
a 
special 
treatment"

r'same
as 
this
'

// Literal strings are compile-time constants


// Booleans
// type
bool 

// literals -> compile-time constants
true
false

// RUNES AND GRAPHEME CLUSTERS
// writing unicode in strings
\uXXXX 
// XXXX -> unicode 4-digit hex value
\u{XXXX+}

// more characters
import "package:characters/characters.dart";

// SYMBOLS -> #
// represents an operator or identifier declared in a Dart program
#radix
#bar
#foo
