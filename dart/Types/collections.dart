void main() {

    // LISTS

    // Dart infers that list is a subtype of List containing 'int'
    // list -> List<int> 
    var list = [1, 2, 3, 11.11, "String", Null,]; // Dart Lists, an ordered group of objects

    // unlike records, List are zero-based indexed
    
    // Creating a compile-time list
    var constantList = const [1, 2, 3];
    // constantList[0] = 1; // error 

    print(list);


    // SETS
    // An unordered collection of unique items.
    // Created through set literals or Set
    var halogens = { 
            "fluorine",
            "chlorine",
            "bromine",
            "iodine",
            "astatine",
        };

    // Creating empty Sets
    var names = <String>{};
    Set<String> names2 = {};

    // var names = {}; // Creates a map, not a set

    // Adding elements to a set
    var elements = <String>{};
    elements.add("fluorine");
    elements.addAll(halogens);

    print(elements);

    // compile-time Set
    var constantSet = const {};

    // Maps
    // an objects that associates keys and values

    // type inferred as Map<String, String>
    var gifts = {
        "first": "partridge",
        "second": "turtledoves",
        // 2.4: "i", this works, I don't understand why
    };

    // type inferred as Map<int, String>
    var nobleGases = {
        2: "helium",
        10: "neon",
        18: "argon",
        // "halo": 42, this works too, I don't understand why
    };

    // adding key-value pairs
    nobleGases[21] = "alewa";
    gifts["third"] = "mango";

    print(gifts);
    print(nobleGases);

    // Map Constructor
    var giftsc = Map<String, String>();
    giftsc["first"] = "toffee";

    var gifts2 = Map<int, String>();
    gifts2[11] = "ElevenToes";

    // Retrieving a value from a map using the subscript []
    print(gifts["third"]);
    print(gifts["juneteenth"]); // return null

    // length of key-value pairs
    print("Lenght of key-value pairs in ${gifts.length}");

    // compile-time const Map
    var compTimeMap = const {
        2: "helium",
        3: "hydrogen",
    };

    // OPERATORS
    // Spread operators
    // ... spread operator
    // ...? null-aware operator
    // allows insertion of multiple values into collections
    var listn = [1,23,4,45,43];
    var listn2 = [0, ...listn];

    // avoids null dereference errors
    var listn2 = [0, ...?listn]; 

    // CONTROL FLOW OPERATORS
    //  collection if 
    // collection for
    var nav = ["Home", "Furniture", "Plants", if (promoActive) "Outlet"];
    var navcase = ["Home", "Furniture", "Plants", if (login case "Manager") "Inventory"];

    var listOfInts = [1,23,4,45];
    var listOfStrings = ["#0", for (var i in listOfInts) "#$i"];

    print(listOfStrings);

}