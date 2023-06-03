// Top Level Variable
late String description;

void main() {
    // stores reference
    // stores a reference to an object of type inferred e.g String
    // you can change a type by specifying it
    // String 
    // Object -> not restricted to a single type
    // var name = "Bob";
    // String name "Bob"; // Coming from Rust, I like this


    /// NULL SAFETY
    // Dart's compiler detects and stops null deference errors at compile time
    // null deference errors happens when you accidentally access a property or method
    // on an expression that evaluates to null
    // exceptions: null supports a prop or method toString()
    String? name; // Nullable type. Can be 'null' or a string.
    // String name; // Non-nullable type. Cannot be 'null' but can be a String.

    // Variables must be initialized before use
    // Nullable variables default to null, init by default. 

    // DEFAULT VALUE
    // everything in dart is an object

    int? lineCount; // default to null
    assert(lineCount == null);

    // for null safety you init all non-null variables
    // int lineCount = 0;

    // local variables can be declared without init but must be init before use
    // int lineCount;

    // if (weLikeToCount) {
    //     lineCount = countLines();
    // } else {
    //     lineCount = 0;
    // }

    // print(lineCount);


    // LATE VARIABLES
    // use cases
    // 1. declaring non-null variables that are init after its declaration
    // 2. lazily init variables
    // When dart fails to detect a non-null set to null value before use in
    // Top level variables and Instances

    // Usually Dart can detect that a non-null variable that is declared with init 
    // but init later before use but in situation where it can't like 
    // Top Level Variables and Instance, You use the "late" to precede the variable declaration
    description = "Feijoada!";
    print(description);

    late String temperature = readThermometer(); // Lazily initialized

    // FINAL AND CONST
    // If you never intend to change variable 
    // const -> compile-time constant -> are implicitly final
    // final -> set only once -> can't be changed

    // [NOTE] Instance variables can be final but not const.
    // so final is like some kind of meta type?
    final name = "Bob"; // without a type annotation -> set only once
    final String nickname = "Bobby"; // string annotation 

    // x static analysis: error/warning 
    name = "Alice"; // Error: A final variable can only be set once

    // const
    const bar = 100000; // Unit of pressure (dynes/cm2)
    const double atm = 1.02325 * bar; // Standard atmosphere 

    // declaring constant values, constructors
    var foo = const [];
    final bar = const [];
    const baz = [];

    // you can change the value non-final, non-const const values
    foo = [0,1];
    // you can't change the value of a const variable
    baz = [43]; // Error: Constant variables can't be assigned a value

    const Object i = 3; // const Object of value of type int
    const list = [i as int]; // type casting
    const map = {
        if (i is int) i: "int" // Use is and collection if.
    };

    const set = {
        if (list is List<int>) ..list // ...and a spread
    };
    // [NOTE]
    // final can't be changed but its fields can be but const and its fields are immutable 
}