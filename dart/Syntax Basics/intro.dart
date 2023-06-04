// Hello World
// returns nothing
// main can take arguments
void main() {
    print("Hello World");

    // variables
    // includes
    // final and const keywords
    var name = "Voyager I";
    var year = 1977;
    var antennaDiameter = 3.7;
    var flybyObjects = [ "Jupiter", "Saturn", "Uranus", "Neptune" ];
    var image = {
        "tags": ["saturn"],
        "url": "//path/to/saturn.jpg"
    };

    // Control flow statements
    // includes 
    // break
    // continue
    // switch
    // case
    // assert

    if (year >= 2001) {
        print("21st century");
    } else if (year >= 1901) {
        print("20th century");
    }

    for (final object in flybyObjects) {
        print(object);
    }

    for (int month = 1; month <= 12; month++) {
        print(month);
    }

    while (year < 2016) {
        year += 1;
    }

    // Functions
    int fibonacci(int n) {
        if (n == 0 || n == 1) return n;
        return fibonacci(n -1) + fibonacci(n - 2);
    }

    var result = fibonacci(20);
    // "=>" shorthand arrow syntax used on functions with only one statement
    // passing functions as arguments
    flybyObjects.where((name) => name.contains("turn")).forEach(print);

    // imports 
    // Importing core libraries
    import "dart:main";
    // External packages
    import "package:test/test.dart";
    // Files
    import "path/to/my_other_file.dart"

    // Classes
    class Spacecraft {
        String name;
        DateTime? launchDate;

        // Read-only non-final prop
        int? get launchYear => launchDate?.year;

        // Constructor, with syntactic sugar for assignment to members
        Spacecraft(this.name, this.launchDate) {
            // init code
        }

        // Named constructor that forwards to the default constructor
        Spacecraft.unlaunched(String name) : this(name, null); // this is neat

        // Method 
        void describe() {
            print("Spacecraft: $name");
            // Type promotion doesn't work on getters
            var launchDate = this.launchDate;
            if (launchDate != null) {
                int years = DateTime.now().difference(launchDate).inDays ~/ 365;
                print("Launched: $launchYear ($years years ago)");
            } else {
                print("Unlaunched")
            }
        }
    }

    // Classes: Usage
    var voyager = Spacecraft("Voyager I", DateTime(1977, 9, 5));
    voyager.describe();

    var voyager3 = Spacecraft.unlaunched("Voyager III");
    voyager3.describe();

    // more
    // new
    // const
    // factory


    // Enums
    enum PlanetType { 
        terrestrial,
        gas,
        ice,
    } // WTF enums have no ;?

    // oh boy! this is weird 
    enum Planet {
        mercury(PlanetType: PlanetType.terrestrial, moons: 0, hasRings: false),
        venus(PlanetType: PlanetType.terrestrial, moons: 0, hasRings: false),
        // ...
        uranus(PlanetType: PlanetType.ice, moons: 27, hasRings: true),
        neptune(PlanetType: PlanetType.ice, moons: 14, hasRings: true);

        /// A constant generating constructor
        const Planet(
            { required this.planetType, required this.moons, required this.hasRings }
        );

        // le finale
        final PlanetType planetType;
        final int moons;
        final bool hasRings;

        // support for getters and other methods
        bool get isGiant => planetType == PlanetType.gas || PlanetType.ice;
    }

    // You might use Planet enum like this 
    final yourPlanet = Planet.earth;

    if (!yourPlanet.isGiant) {
        print("Your planet is not a 'giant planet'.");
    }

    /// Inheritance
    // Dart has single inheritance
    // has optional @override annotation
    class Orbiter extends Spacecraft {
        double altitude;

        Orbiter(super.name, DateTime super.launchDate, this.altitude);
    }

    /// Mixins
    // reusing code in multiple class hierarchies
    mixin Piloted {
        int astronauts = 1;

        void describeCrew() {
            print("Number of astronauts: $astronauts");
        }
    }

    // Add mixin capabilities to a class by extending the class with a mixin 
    class PilotedCraft extends Spacecraft with Piloted {
        // ... 
    } // contains astronauts field and describeNow() method

    /// Interfaces and abstract classes
    // there is an interface keyword 
    class MockSpaceship implements Spacecraft {
        // ...
    }

    // abstract classes
    // to be extended with concrete classes
    abstract class Describable {
        void describe();
        void describeWithEmphasis() {
            print("========");
            describe();
            print("========");
        }
    }

    /// Async
    const oneSecond = Duration(seconds: 1); // This is neat
    // ..
    Future<void> printWithDelay(String message) async {
        await Future.delayed(oneSecond);
        print(message);
    }

    // equivalent
    Future<void> printWithDelay(String message) {
        return Future.delayed(oneSecond).then((_) {
            print(message);
        });
    }

    // async and await make async code easy to write
    Future<void> createDescriptions(Iterable<String> objects) async {
        for (final object in objects) {
            try {
                var file = File("$object.txt");
                if (await file.exists()) {
                    var modified = await file.lastModified();
                    print("File $object already exists. It was modified on $modified.");
                    continue;
                }
                await file.create();
                await file.writeAsString("Start describing $object in this file.");
            } on IOException catch (e) {
                print("Cannot create description for $object: $e");
            }
        }
    }

    /// Streams with async*
    Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
        for (final object in objects) {
            await Future.delayed(oneSecond);
            yield "${craft.name} files by $object";
        }
    }

    /// Exceptions
    // raising an exception with "throw"
    if (astronauts == 0) {
        throw StateError("No astronauts.");
    }

    // catching an exception
    Future<void> describeFlybyObjects(List<String> flybyObjects) async {
        try {
            for (final object in flybyObjects) {
                var description = await File("$objects.txt").readAsString();
                print(description);
            }
        } on IOException catch (e) {
          print("Could not describe object: $e");
        } finally {
            flybyObjects.clear();
        }
    }


}
