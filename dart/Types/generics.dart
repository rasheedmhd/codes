// Generics for type safety
// Generics for avoiding code duplication
void main() {

    // Type Safety
    var names = <String>[];
    names.addAll(["Seth", "Kathy", "Lars"]);
    names.add(43); // error
    names.add(43.toString()); // error fixed


    // Code duplication
    abstract class ObjectCache {
        Object getByKey(String key);
        void setByKey(String key, Object value);
    }

    abstract class ObjectCache {
        String getByKey(String key);
        void setByKey(String key, String value);
    }

    abstract class ObjectCache {
        int getByKey(int key);
        void setByKey(String key, int value);
    }

    // using generics
    // T is a placeholder for a type that will be specified later
    abstract class Cache<T> {
        T getByKey(String key);
        void setByKey(String key, T value);
    }

    // USING COLLECTION LITERALS
    // List, Set and Map literals can be parameterized
    // by adding their type annotations before the opening bracket
    // [] - {} - ()
    var names1 = <String>["Seth", "Kathy", "Lars"];
    var uniqueNames = <String>{"Seth", "Kathy", "lars"};

    var pages = <String, String>{
        "index.html": "Homepage",
        "robots.txt": "Hints for web robots",
        "humans.txt": "Hints for breathing robots", 
    };


    // Using parameterized types with constructors
    // set the type in <> right after the class name
    var nameSet = Set<String>.from(names);
    // creates a map with keys of type int and values of type View
    var views = Map<int, View>();

    print(pages);
    print(nameSet);

    // Generic collections and types
    // Generic types are reified (concrete) -> carries
    // type information through runtime

    // Restricting the parameterized type - 'extends'
    // restricting to using only subtypes of a type(SuperType)
    // Making a type non-null by making it a subtype of Object is
    // mostly used. (instead of Object?)

    class Foo<T extends Object> {
        // Ensures that any type late provided for Foo must be non-nullable
    }

    class Foo<T extends SomeArbitraryBaseClass> {
        // impl 
        String toString() => "Instance of 'Foo<$T>'";
    }

    class Extender extends SomeArbitraryBaseClass {
        // impl
    }

    // It is okay to use the SuperType as a type or any of its subtypes
    var someBaseClassFoo = Foo<SomeArbitraryBaseClass>();
    var extenderFoo = Foo<Extender>();

    // it is okay to specify no argument 
    var foo = Foo();
    print(foo); // Instance of "Foo<SomeBaseClass>"

    // specifying a non-SomeArbitraryBaseClass leads to an error
    var foo = Foo<Object>(); 

    // Using Generic Methods
    // methods and functions also allow type arguments
    T first<T>(List<T> ts) {
        // some initial work or error checking..
        T tmp = ts[0];
        // do epic sht
        return tmp;
    }

    // non-generic of the above function
    String first(List<String> ts) {
        String tmp = ts[0];
        return tmp;
    }


}

// names is a list of string
// adding an int to it results in an error