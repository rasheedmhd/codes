// LIBRARIES AND IMPORTS
// built-in libs
import "dart:html";

// libs provided by package manager
import "package:test/test.dart";

// specifying lib prefix with "as"

import "package:lib1:lib1.dart";
import "package:lib2:lib2.dart" as lib2;

// Using methods/function from imported libs
// lib1
Element element1 = Element();

// lib2
lib2.Element element2 = lib2.Element();


// part importation
// import only Foo
import "package:lib1:lib1.dart" show Foo;

// import all except Foo
import "package:lib9:lib9.dart" hide Foo;

// lazy loading - load on demand
import "package:greetings/bonjour.dart" deferred as hello;

// how to use a lazily loaded lib
Future<void> greet() async {
    await hello.loadLibrary();
    hello.printGreeting();
}

// library directives
// @TestOn
// @export
// @part

