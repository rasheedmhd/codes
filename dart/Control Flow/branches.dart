//

if
if-case
switch 



// if-case
if (pair case [int x, int y]) return Point(x, y);

// if-case with else 
if (pair case [int x, int y]) {
    print("Was coordinate array $x, $y");
} else {
    throw FormatException("invalid coordinates");
}

// switch exp vr switch statement
// cases don't start with a case keyword
// a case body is a single exp
// each case must have a body
// => instead o f :
// case are separated by ,
// default = _

// Exhaustiveness Checking
// non-exhaustive
switch (nullableBool) {
    case true:
        print("yes");
    case false:
        print("no");

    // must add 
    // default
    // _
}

sealed class Shape {}

class Square implements Shape {
    final double length;
    Square(this.length);
}

class Circle implements Shape {
    final double radius;
    Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
    Square(length: var l) => l * l,
    Circle(radius: var r) => math.pi * r * r
};

// Guard clause
when after case 
// eg
case [a, b] when b > a: 
;