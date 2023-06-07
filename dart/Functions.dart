// Functions

void main() {
    // String StringPrinter() {
    //     String name = "Osman";
    //     print(name);
    //     return name;
    // }
    StringPrinter();
}


// // Example
// bool isNoble(int atomicNumber) {
//     return _nobleGases[atomicNumber] != null;
// }

// // function without type annotations
// isNoble(int atomicNumber) {
//     return _nobleGases[atomicNumber] != null;
// }


// shorthand
// arrow syntax
//bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;

// converting my function to shorthand
void StringPrinter() => print("Osman from shorthand");
// StringPrinter() => print("Osman from shorthand");

// Parameters
// Can take required positional arguments
// which can be followed by named parameters
// or by optional positional arguments but not both

// Named parameters
// optional unless marked by required

void enableFlags({bool? bold, bool? hidden}) { ... }

// calling functions
enableFlags(bold: true, hidden: false);
enableFlags();

// default values
void enableFlags({bool? bold = false, bool? hidden}) { ... }

enableFlags(bold: true);

// mandatory values
const Budget(required String name, required Wallet wallet);

const Scrollbar({super.key, required Widget child});

// Optional Positional parameters
// are wrapped in []
// !default values, their types must be nullable
String say(String from, String msg, [String? device]) {
    //
    var result = "$from says $msg";
    if (device != null) {
        result = "$result with a $device";
    }
}

// calling without optional parameter
assert(say("Bob", "Howdy") == "Bob says Howdy");

// calling with the 3rd optional parameter
say("Bobby", "Howdy", "smoke signal");

// setting non-nullable default values; they must be compile-time const
String say(String from, String msg, [String device = "telegram"]) {
    //
    var result = "$from says $msg";
    if (device != null) {
        result = "$result with a $device";
    }
}

// main()

// Functions are first-class objects

// Anonymous functions

// Lexical closures
// captures their environment - lexical scope 
// even when the function is used outside the original scope 

Function makeAdder(int addBy) {
    return (int i) => addBy + i;
}

void main() {
    // Create a fn that adds 2
    var add2 = makeAdder(2);

    // Create a fn that adds 4
    var add4 = makeAdder(4);
}

// Generators
// -> lazily produce sequence of values
// Dart has 2 types of Generators
// 1. Synchronous -> returns Iterable -> mark fn body with sync*
//    use yield statements to deliver values
// 2. Asynchronous -> returns a Stream -> mark fn body with async*
//    use yield statements to deliver values


Iterable<int> naturalsTo(int n) sync* {
    int k = 0;
    while (k < n) yield k++;
}

Stream<int> asyncnaturalsTo(int n) async* {
    int k = 0;
    while (k < n) yield k++;
}

// use yield* to improve recursive generators
Interable<int> naturalsDownFrom(int n) sync* {
    if (n > 0) {
        yield n;
        yield* naturalsDownFrom(n -1);
    }
}