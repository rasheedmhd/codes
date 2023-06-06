// THE DART TYPE SYSTEM

// Static typing in Dart is mandatory
// annotations are optional bc of type inference
// Dart uses compile-time and runtime techniques to enforce type checking

// Dart's static analyzer weeds out bugs during compilation through type checking


void printInts(List<int> a) => print(a); 

void main() {

    // code with static typing error
    // final list = [];
    // // list = [44,5, 5];
    // list.add(1);
    // list.add("2");
    // printInts(list); // error
    // print(list);

    // fixing the static type error
    final s_list = <int>[];
    s_list.add(1);
    // s_list.add("2"); // type error
    s_list.add(2);
    printInts(s_list);

    // Soundness
    // In sound Dart, types can't lie.

    // TIPS FOR PASSING STATIC ANALYSIS
    // 1. Use sound return types when overriding methods 
    class Animal {
        void chase(Animal a) {...}
        Animal get parent => ...
    }

    class HoneyBadger extends Animal {
        @override
        void chase(Animal a) {...}

        @override
        HoneyBadger get parent => ...
    }

    class HoneyBadger extends Animal {
        @override
        void chase(Animal a) {...}

        @override
        HoneyTree get parent => ... // static type check error
    }

    // The parameter of an overridden method must have the same type or a supertype of the corr parameter in the superclass
    // don't tighten the parameter -> replacing the type with the subtype of the OG parameter


    // use the 
    covariant 
    // keyword if you have a valid reason to use a subtype

    class Animal {
        void chase(Animal a) { ... }
        Animal get parent => ...
    }

    class HoneyBadger extends Animal {
        @override
        // an HoneyBadger chases anything 
        // os it is OK to do this
        void chase(Object a) {...}

        @override
        Animal get parent => ...
    }

    class Mouse extends Animal {...}

    class Cat extends Animal {
        @override
        // Mouse is subtype of Animal
        // this is tightening and is not Okay
        void chase(Mouse x) {...}
    }

    // not type safe
    Animal a = Cat();
    a.chase(Alligator());

    // RUNTIME CHECKS
    // Runtime checks happen when some type checks could not be done at compile time
    List<Animal> animals = [Dog()];
    List<Cat> cats animals as List<Cat>;

    // TYPE INFERENCE
    // analyzer infers types given enough info
    // it enough info isn't given out it results to using a dynamic type

    // FIELD AND METHOD INFERENCE
    // an overriding field/method with no type takes the type of the field/method of the superclass that it is overriding

    // initializing a field during declaration gives the field the type of the initial value(inference). i.e the field not been statically declared and doesn't inherit a type form a super class

    // STATIC FIELD INFERENCE
    // Types are inferred from the initializer
    // inference fails in 'cycle's -> inferring the type of the variable depending on knowing the type of the variable

    // LOCAL VARIABLE INFERENCE
    // inferred from initializer if any
    // subsequent assignments not taken into consideration 
    // add type notations else you might have tightening down the line
    var x = 3; // int
    x = 4.0; // double -> error

    num y = 3; // could be double or int
    y = 4.0; // safe


    // TYPE ARGUMENT INFERENCE
    // based on downward info and context of occurrence
    // & upward info from the args
    // don't fight with the analyzer -> explicitly specify your types
    // in inference, map() return type = upward info

    // SUBSTITUTING TYPES
    // replacing with a subtype or supertype
    // think consumers and producers
    // Consumers -> SuperType
    // Producers -> SubType





}