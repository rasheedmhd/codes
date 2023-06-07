// Production quality throws types that implement
Error or 
Exception


// catch
try {

} on <Exception> {
    // exception handling code
}

// handling multiple exceptions
try {

} on <Exception> {
    // exception handling code
} on Exception catch (e) {
    // exception handling
} catch (e) {
    //
}

// we can use
// "on" or "catch" or both to catch exceptions
// "on" for specific exceptions
// "catch" for when we need an exception object "e"

// passing 2 parameters to "catch"
catch (e, s);
// e -> arrow thrown
// s -> stack trace

// Partial handling and allowing propagation

void rethrowE() {
    try {
        //
    } catch (e) {
        // handle
        rethrow; // allows callers to see the exception
    }
}

// seeing exception rethrow(ned)
try {
    rethrowE();
} catch (e, s) {
    // do epic sht
}

// finally
// wildcard 
// happens regardless of exception handling

// assert
