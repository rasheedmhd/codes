// PATTERN REFERENCE


// In Ascending Order
// relational  -> logical-and -> Logical-or

// Post-fix unary patterns (same level)
// cast = null-check = null-assert

// Primary Patterns share the highest precedence
// record 
// list
// map
// Object

||
&&
// Relational
==
<
!=
>
<=
>=
// end

// Cast
foo as String

// Null-check
subpattern?

// Null-assert
// permit only non-null
// throw if null is matched
List<String?> row = ["user", null];
switch (row) {
    case ["user", var name!]: // ...
    // "name" is a non-nullable string
}

// eliminate null values from val decla
(int?, int?) position = (2,3);

var (x!, y!) = position;


// Constant
123
null
"string"
math.pi
SomeClass.constant 
const
Thing(1,2)
const (1,2)

// Rest
// ...
var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
// Prints "1 2 [3, 4, 5] 6 7".
print('$a $b $rest $c $d');


var (untyped: untyped, typed: int typed) = record;
var (:untyped, :int typed) = record;

switch (record) {
    case (untyped: var untyped, typed: int typed) => // ...
    case (:var, :int typed) => // ...
}


// null-check and null-assert
switch (record) {
    case(checked: var checked?, asserted: var asserted!) => //..
    case(:var checked?, :var asserted?) => // ...
}

// cast as pattern 

var (untyped: untyped as int, typed: typed as String) = record;
var (:untyped as int, :typed as String) = record;


// Object
// SomeClass(x: subpattern1, y: subpattern2)
switch (shape) {
    case Rect(width: var w, height: var h) => //....
}

// A getter name can be omitted and inferred from the variable pattern
// or identifier pattern in the field subpattern.

var Point(:x, :y) = Point(1, 2);


// Wildcard 
_



