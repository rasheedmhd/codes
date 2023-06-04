// Are
// 1. anonymous
// 2. immutable
// 3. aggregate type
// 4. fixed-size
// 5. heterogeneous 
// 6. typed

// let you bundle multiple objects into a single object
void main() {

    // RECORD FIELDS
    var record = ("first", a: 2, b: true, "last");

    // why doesn't accessing the record fields start with 0?

    print(record.$1); // prints "first"
    print(record.a); // prints 2
    print(record.b); // prints true
    print(record.$2); // prints last

    // RECORDS TYPES
    // defined by individual fields types
    (num, Object) pair = (42, "a");

    var first = pair.$1; // Static type 'num', runtime type 'int'
    var second = pair.$2; // Static type 'Object', runtime type 'String'

    // RECORDS EQUALITY
    // records are equal if they have the same shape 
    // and fields have the same value
    // named fields order is not part of a records shape
    // therefore does not affect equality 
    (int a, int b, int c) point = (1, 2, 3);
    (int r, int g, int b) color = (1, 2, 3);

    print(point == color); 

    ({ int x, int y, int z}) pointer = (x: 1, y: 2, z: 3);
    ({ int r, int y, int z}) counter = (r: 1, y: 2, z: 3);
    print(pointer == counter); 

    print("printing from records.dart");

    // MULTIPLE RETURNS
    // functions can return multiple values bundle together
    // we use pattern matching to destructure values

    // returns two values, a String and an int in a record
    (String, int) userInfo(Map<String, dynamic> json) {
        return (
            json["name"] as String, 
            json["age"] as int
        );
    }

    final json = <String, dynamic> {
        "name": "Dash",
        "age": 10,
        "color": "blue",
    };

    // Destructing using a record pattern
    var (name, age) = userInfo(json);
    /*
        var info = userInfo(json);
        var name = info.$1;
        var age = info.$2;
    */

    print(userInfo);
}

// // Syntax
// var record = ("first", a: 2, b: true, "last");

// (int, int) swap((int, int) record) {
//     var (a, b) = record;
//     return (b, a);
// }

// // Record type annotation in a variable declaration 
// (String, int) record;

// // Initialize it with a record expression
// record = ("Hello, Sir", 5);

// // Record type annotation in a variable declaration
// ({int a, bool b}) = record;

// // Initialize it with a record expression
// record = (a: 123, b: true);


// ({int a, int b}) recordAB = (a: 1, b: 2);
// ({int x, int y}) recordXY = (y: 3, x: 4);

// // recordAB = recordXY;

// // In a record type annotation, you can name the positional
// // arguments but that doesn't form part of the record
// (int a, int b) record123 = (1, 2);
// (int x, int y) record321 = (2, 3);

// record123 = record321;
