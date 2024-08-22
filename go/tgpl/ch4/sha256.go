// package main

// import (
// 	"crypto/sha256"
// 	"fmt"
// )

// func main() {
// 	c1 := sha256.Sum256([]byte("x"))
// 	c2 := sha256.Sum256([]byte("X"))
// 	fmt.Printf("%x\n%x\n%t\n%T\n", c1, c2, c1 == c2, c1)
// 	// Output:
// 	// 2d711642b726b04401627ca9fbac32f5c8530fb1903cc4db02258717921a4881
// 	// 4b68ab3847feda7d6c62c1fbcbeebfa35eab7351ed5e78f4ddadea5df64b8015
// 	// false
// 	// [32]uint8
// 	// &x = prints elements of an array
// 	// &t = prints a boolean results
// 	// &T = prints the type of a value
// 	//
// 	// Go treats ARRAYS as pass-by-value
// 	// https://www.ibm.com/docs/en/zos/2.4.0?topic=calls-pass-by-value
// 	// Uses pointers for pass-by-reference

// 	// zero(&b)
// 	//
// 	// SLICES
// 	months := [...]string{
// 		1:  "January",
// 		2:  "February",
// 		3:  "March",
// 		4:  "April",
// 		5:  "May",
// 		6:  "June",
// 		7:  "July",
// 		8:  "August",
// 		9:  "September",
// 		10: "October",
// 		11: "November",
// 		12: "December",
// 	}

// 	Q2 := months[4:7]
// 	summer := months[6:9]
// 	fmt.Println(Q2)     // ["April" "May" "June"]
// 	fmt.Println(summer) // ["June" "July" "August"]

// }
