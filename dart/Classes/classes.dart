import "dart:math";
// Every object is an instance of a class

// class and mixin based inheritance
// all classes except Null descend from Object

// mixin-base inheritance
// every class has one superclass(except for Object?) but a class body can be reused
// in multiple class hierarchies

// Extensions methods allow for a class to be added with functionalities without changing the class or creating a subclass


// Instance Vars
class Point {
    double? x;
    double? y;
    double z = 0;
}

point.x = 4; // setter method 
assert(point.x == 4); // getter method
assert(point.y == null); // Values default to null

class ProfileMark {
    final String name;
    //..
}

// Implicit Interfaces
// implements -> support a class APIs without inheriting the class'
// implementation

// class implements one or more interfaces by declaring them in an
// implements clause and then provide the APIs required by the interface

class Person {
    // In the Interface but visible only in this lib
    final String _name;

    // constructor -> not in the Interface
    Person(this._name);

    // In interface
    String greet(String who) => "Hello, $who, I am $_name.";
}

// Implementing Person Interface
class Impostor implements Person {
    String get _name => "";

    String greet(String who) => "Hi $who. Do you know who I am?";
}

String greetBob(Person person) => person.greet("Bob");

// Implementing multiple interfaces by a class in one go
class Point implements Comparable, Location {...}

// Class vars and methods
static // class wide vars and methods
// static vars (class vars)
// -> aren't initialized till they are used.
class Queue {
    static const initialCapacity = 16;
    // ..
}

// Static Methods
// don't operate on instances, hence have no access to "this"
// invoked directly on classes
// have access to static vars
// can be used as compile-time constants

class Point2 {
    double x, y;
    Point(this.x, this.y);

    static double distanceBtn(Point a, Point b) {
        var dx = a.x - b.x;
        var dy = a.y - b.y;
        return sqrt(dx * dx + dy * dy);
    }
}

void main() { 

    // Class Members
    var p = Point(2,2);
    // Get y(value)
    assert(p.y == 2);
    double distance = p.distanceTo(Point(4,4));

    // ?. -> avoid exception with leftmost operand is null 
    var a = p?.y;

    // Using constructors
    // can be ClassName or ClassName.identifier

    var p1 = Point(2,2);
    var p2 = Point.fromJson({"x": 1, "y": 2});

    // optional "new"
    var p1 = new Point(2,2);
    var p2 = new Point.fromJson({"x": 1, "y": 2});

    // constant constructors
    // to create compile-time constants
    var p = const ImmutablePoint(2,2);

    // omitting const keyword in a constant context

    const pointAndLine = const {
        "point": const [const ImmutablePoint(0,0)],
        "line": const [const ImmutablePoint(1,10), const ImmutablePoint(-2, 11)],
    };

    const pointAndLine =  {
        "point": [ ImmutablePoint(0,0)],
        "line": [ ImmutablePoint(1,10), ImmutablePoint(-2, 11)],
    };

    // Getting an object's type
    // <Object>.runtimeType

}