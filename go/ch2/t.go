// Example 2-2. Type conversions

package main

import "fmt"

// Immutable variables
const cx int64 = 10

const (
	idKey   = "id"
	nameKey = "name"
)
const z = 20 * 10

func main() {

	var x int = 10
	var y float64 = 30.2
	var sum1 float64 = float64(x) + y
	var sum2 int = x + int(y)
	fmt.Println(sum1, sum2)

	var xx int = 10
	var b byte = 100
	var sum3 int = xx + int(b)
	var sum4 byte = byte(x) + b
	fmt.Println(sum3, sum4)

	// Go doesn’t provide a way to specify that a value calculated at runtime is
	x2 := 5
	y2 := 10
	const z = x2 + y2

	const cy = "hello"
	fmt.Println(cx)
	fmt.Println(cy)
	cx = cx + 1 // this will not compile!
	cy = "bye"  // this will not compile!

}

// Constants in Go are a way to give names to literals.
// They can only hold values that the compiler can figure out at compile time.
//
// This means that they can be assigned:
// • Numeric literals
// • true and false
// • Strings
// • Runes
// • The values returned by the built-in functions complex, real, imag, len, and cap
// • Expressions that consist of operators and the preceding values
