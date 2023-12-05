import 'package:hotreloader/hotreloader.dart';

// Future<void> main(List<String> args) async {
//   // instantiate a reloader that by monitors the project's source code folders for changes
//   final reloader = await HotReloader.create();

//   // ... your other code
//   // test();
//   // cleanup
//   final check = 1;

//   final String test = "Test Reloading";

//   while (check == 1) {
//     print("Hello World!");
//   }

//   reloader.stop();
// }

// void main() {
//   final check = 1;

//   while (check == 1) {
//     print("Hello World, Running Server!");
//   }
// }

void main() async {
  while (true) {
    print("Hello World, Running Server!");

    // Introduce a delay to simulate work.
    await Future.delayed(Duration(seconds: 7));
  }
}
