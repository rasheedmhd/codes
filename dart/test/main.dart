// import 'package:hotreloader/hotreloader.dart';


// import 'dart:io';

// import 'package:shelf/shelf.dart' as shelf;
// import 'package:shelf/shelf_io.dart' as io;
// import 'package:shelf_hotreload/shelf_hotreload.dart';

// // Run this app with --enable-vm-service (or use debug run)
// void main() async {
//   // withHotreload(() => createServer());
//   withHotreload(() => createRunner());
// }

// Future<HttpServer> createRunner() async {
//     print("Hello World, Running Server!");

//     // Introduce a delay to simulate work.
//     await Future.delayed(Duration(seconds: 7));
// }

// // Future<HttpServer> createServer() {
// //   handler(shelf.Request request) => shelf.Response.ok('hot!');
// //   return io.serve(handler, 'localhost', 8080);
// // }



// // Future<void> main(List<String> args) async {
// //   // instantiate a reloader that by monitors the project's source code folders for changes
// //   final reloader = await HotReloader.create();

// //   // ... your other code
// //   // test();
// //   // cleanup
// //   final check = 1;

// //   final String test = "Test Reloading";

// //   while (check == 1) {
// //     print("Hello World!");
// //   }

// //   reloader.stop();
// // }

// // void main() {
// //   final check = 1;

// //   while (check == 1) {
// //     print("Hello World, Running Server!");
// //   }
// // }

// // void main() async {
// //   while (true) {
// //     print("Hello World, Running Server!");

// //     // Introduce a delay to simulate work.
// //     await Future.delayed(Duration(seconds: 7));
// //   }
// // }
