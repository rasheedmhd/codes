// // all keys are of the same type
// // all values are of the same type
// // but values/keys needn't be the same type as keys/values
// // keys must be comparable with ==
// // use make() to create a map which is a ref to a hashmap
// package main

// import "fmt"

// func main() {
// 	ages := make(map[string]int) // mapping from strings to ints
// 	// Using a map literal to create a new map populated with some initial key/value pairs:
// 	// map literal
// 	ages_literal := map[string]int{
// 		"alice":   31,
// 		"charlie": 34,
// 	}

// 	// Making/creating a map and populating later with key matching/subscript notation
// 	ages_not_literal := make(map[string]int)
// 	ages_not_literal["alice"] = 31
// 	ages_not_literal["charlie"] = 31

// 	fmt.Println(ages_literal["charlie"])
// 	fmt.Println(ages["charlie"])

// 	// Deleting items from a map
// 	delete(ages, "aliceddd") // remove element ages["alice"]

// 	// Modifying maps
// 	ages_not_literal["j"] = ages_not_literal["j"] + 11
// 	fmt.Println(ages_not_literal["j"])

// 	// With Shorthand notation
// 	ages_not_literal["j"] += 11
// 	fmt.Println(ages_not_literal["j"])

// 	// We can't assign a map element to a variable
// 	// _ = &ages["bob"] // compile error: cannot take address of map element

// 	// looping
// 	for name, age := range ages_literal {
// 		fmt.Printf("%s\t%d\n", name, age)
// 	}

// 	// Checking the presence of a key in a hash map
// 	age, ok := ages["bob"]
// 	if !ok { /* "bob" is not a key in this map; age == 0. */
// 	}

// 	// often combined, like this:
// 	if age, ok := ages["bob"]; !ok { /* ... */
// 		fmt.Print(age)
// 	}

// 	fmt.Print(age)

// 	// Subscripting a map in this context yields two values;
// 	// 2nd is a boolean that reports whether the element was present.
// 	// The boolean variable is often called ok, especially if it is immediately used in an if condition.
// 	//

// }

// // As with slices, maps cannot be compared to each other; ONLY nil.
// // To test whether two maps contain the same keys and the same associated values,
// // we must write a loop like this
// func equal(x, y map[string]int) bool {

// 	if len(x) != len(y) {
// 		return false
// 	}

// 	for k, xv := range x {
// 		if yv, ok := y[k]; !ok || yv != xv {
// 			return false
// 		}
// 	}

// 	return true
// }
