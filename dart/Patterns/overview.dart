// What patterns do
// 1. match 
// 2. destructure
// 3. match and destructure



// check values
// 1. shape
// 2. is certain constant
// 3. = something else
// 4. has certain type

void main() {
    int number = 1;
    switch (number) {
        case 1:
            print('one');
    }

    // Destructuring
    // var numList = [1,24,4];
    // var [a, b, c] = numList;
    // print(a + b + c);

    // // Var Decla
    // List listsa = <int>[14,44];
    // //var (x, [y, z]) = ('str', [1,3]);
    // var (x, [y, z]) = ('str', listsa);

    // print(y + z);
    // print(x);

    // // Var Assign
    // var (a, b) = ("left", "right");

    // Switch statements and expressions
    // logical or
    // var isPrimary = switch (color) {
    //     Color.red || Color.yellow || Color.blue => true,
    //     _ => false
    // };

    // switch (shape) {
    //     case Square(size: var s) || Circle(size: var s) when s > 0:
    //     print("Non-empty symmetric shape");
    // }

    // For and for-in loops
    // object destructuring
    Map<String, int> hist = {
        "a": 23,
        "b": 100,
    };

    for (var MapEntry(key: key, value: count) in hist.entries) { // or :key
        print("$key occured $count times");
    }

    // Destructuring multiple returns
    var info = userInfo(json);
    var name = info.$1;
    var age = info.$2;

    // better
    var (name, age) = userInfo(json);

    // Destructuring class instances
    // i don't understand this yet
    final Foo myFoo = Foo(one: "one", two: 2);
    var Foo(:one, :two) = myFoo;
    print("one $one, two $two");

    // Algebraic Data types
    sealed class Shape {};

    class Square implements Shape {
        final double length;
        Square(this.length);
    }

    class Circle implements Shape {
        final double radius;
        Circle(this.radius);
    }

    double calculateArea(Shape shape) => switch (shape) {
        Square(length: var l) => 1 * 1,
        Circle(radius: var r) => math.pi * r * r,
    }

    // Validating incoming JSON
    // if you already know the structure of data
    var json {
        "user": ["Lily", 13]
    };
    var {"user": [name, age]} = json;

    // without patterns
    if (json is Map<String, Object?> &&
        json.length == 1 &&
        json.containskey("user")) {
            var user = json["user"];
            if (user is List<Object> && 
            user.length == 2 &&
            user[0] is String && 
            user[1] is int) {
                var name = user[0] as String;
                var age = user[1] as int;
                print("User $name is $age years old.");
            }
        }

    if (json case {"user": [String name, int age]}) {
        print("User $name is $age years old.");
    }



}