// UNARY POSTFIX
// e++ e-- () [] ?[] . ?. !

// UNARY PREFIX
// -e !e ~e ++e await e

// MULTIPLICATIVE
// * / % ~/

// ADDITIVE
// + -

// SHIFT
// << >> >>>

// BITWISE AND
// &
// -> XOR
// ^
// -> OR
// |

// RELATIONAL AND TYPE TEST 
// >=
// >
// <=
// as
// is
// is!

// EQUALITY
// == !=

// LOGICAL OR
// ||

// IF NULL
// ??

// CONDITIONAL
// e ? e : e

// CASCADE 
// .. ?..

// ASSIGNMENT
// = *= /= -= &= ^= etc

// TYPE TEST OPERATORS
// as = Typecast / specify library prefixes
// is = True if object has the specified type / impl the interface specified by type
// is! =  True if object doesn't have the specified type

(employee as Person).firstName = "Bobby";

// if not sure use is to check type before using
if (UFO is Quadcopter) {
    // type check
    UFO.motorNumber = 4;
}

// ASSIGNMENT OPERATORS
// ??= assign to if the value to be assigned to is null
a = value;
b ??= value;

// LOGICAL OPERATORS
// !
// ||
// &&

// CONDITIONAL OPERATORS
// cond ? expr1 : expr2
// expr1 ?? expr2 -> returns expr1 if non-null else return expr2

// assign a value based on a boolean expression -> ? and :
var visibility = isPublic ? 'public' : 'private';

// assign a value when checking for null
String playerName(String? name) => name ?? "Guest";

// other variant of ?:
String playerName(String? name) => name != null ? name: "Guest";

// longer variant of ??
String playerName(String? name) {
    if (name != null) {
        return name;
    } else {
        return "Guest";
    }
}

// CASCADE NOTATION
// .. ?..
// allows to make sequence of ops on the same object
var paint = Paint()
..color = Colors.black
..strokeCap = StrokeCap.round
..strokeWidth = 5.0;

// eq
var paint = Paint();
paint.color = Colors.black;
paint.strokeCap = Strake.round;
paint.strokeWidth = 5.0

// if the value can be null
querySelector("#confirm") // Get an object
?..text = "Confirm" // Use its members
..classes.add("important")
..onClick.listen((e) => window.alert("confirmed!"))
..scrollIntoView();

// eqv
var button = querySelector("#confirm");
button?.text = "Confirm";
button?.classes.add("Important");
button?.onClick.listen((e) => window.alert("Confirmed"));
button?.scrollIntoView();

// nesting Cascades
final addressBook = (AddressBookBuilder()
    ..name = "jenny"
    ..email = "jenny@gmail.com"
    ..phone = (PhoneNumberBuilder()
        ..number = "415--555-0100"
        ..label = "home"
    ).build()  
).build();


/// METADATA
// give more information about your code
// @
// 1. @Deprecated
// 2. @deprecated
// 3. @override