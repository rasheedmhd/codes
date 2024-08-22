// package main

// import "fmt"

// var a [3]int // array of 3 integers

// func main() {
// 	// fmt.Println(a[0])        // print the first element
// 	// fmt.Println(a[len(a)-1]) // print the last element, a[2]

// 	// // Print the indices and elements.
// 	// for i, v := range a {
// 	// 	fmt.Printf("%d %d\n", i, v)
// 	// }

// 	// // Print the elements only.
// 	// for _, v := range a {
// 	// 	fmt.Printf("%d\n", v)
// 	// }

// 	// Initializing an Array with an array literal
// 	// var q [3]int = [3]int{1, 2, 3}
// 	// fmt.Println(q[2]) // "0"
// 	// q := [3]int{1, 2, 3}

// 	// Getting the Array length from the array literal with ...
// 	q := [...]int{1, 2, 3}
// 	fmt.Println(q[2]) // "0"

// 	// The size of an array is part of its type, so [3]int and [4]int are different types.
// 	// A list of index and values without using Arrays
// 	type Currency int
// 	const (
// 		USD Currency = iota
// 		EUR
// 		GBP
// 		RMB
// 	)
// 	symbol := [...]string{USD: "$", EUR: "9", GBP: "!", RMB: "<?>"}
// 	fmt.Println(USD, symbol[USD])

// 	// COMPARING ARRAYS
// 	// ARRAYS can be compared with the == and != operators if their elements are of the same type
// 	a := [2]int{1, 2}
// 	b := [...]int{1, 2}
// 	c := [2]int{1, 3}
// 	fmt.Println(a == b, a == c, b == c) // "true false false"
// 	// Remember the length of an ARRAY is part of its type
// 	d := [3]int{1, 2}
// 	fmt.Println(a == d) // compile error: cannot compare [2]int == [3]int
// }
//
// // 	b := [32]byte{}
// // for i := 0; i < 32; i++ {
// // 	b[i] = byte(i + 1)
// // }
// func zero(ptr *[32]byte) {
// 	fmt.Print("&x", ptr)
// 	for i := range ptr {
// 		ptr[i] = 0
// 	}
// 	fmt.Print("&x", ptr)
// }
