// for loops 

void main() {
    var message = StringBuffer('Dart is fun');
    for (var i = 0; i < 5; i++) {
        message.write('!');
    }

    var callbacks = [];
    for (var i = 0; i < 2; i++) {
        callbacks.add(() => print(i));
    }

    for (final c in callbacks) {
        c(); // prints 0, 1
    }

    // for .. in 
    // for-in loops with patterns
    for (final Candidate(:name, :yearsExp) in candidates) {
        print("$name has $yearsExp of experience");
    }

    //.forEach()

    // While and do-while


    // Break and continue
    // break - stop looping
    // continue - skip next loop

}