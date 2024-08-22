// package main

// import "fmt"

// func main() {
// 	months := [...]string{
// 		// 0: initializes to "" by default
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

// 	Z := months[0]
// 	Q2 := months[4:7]
// 	summer := months[6:9]

// 	fmt.Println(Z)
// 	fmt.Println(Q2)     // ["April" "May" "June"]
// 	fmt.Println(summer) // ["June" "July" "August"]

// 	// Detecting common elements
// 	for _, s := range summer {
// 		for _, q := range Q2 {
// 			if s == q {
// 				fmt.Printf("%s appears in both\n", s)
// 			}
// 		}
// 	}

// 	// Slicing beyond cap(s) causes a panic, but slicing beyond len(s) extends the slice, so the result may be longer than the original:
// 	// fmt.Println(summer[:20])    // panic: out of range
// 	// endlessSummer := summer[:5] // extend a slice (within capacity)
// 	// fmt.Println(endlessSummer)  // "[June July August September October]"

// 	// reverse reverses a slice of ints in place.
// 	arr := [...]int{4, 56, 66, 545}
// 	reverse(arr[:])
// 	fmt.Print(arr)
// }

// func reverse(s []int) {
// 	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
// 		s[i], s[j] = s[j], s[i]
// 	}
// }

// // Unlike ARRAYS we can't compare slices with == and !=
// // The std lib has a bytes.Equal for comparing slices of
// // bytes ([]byte)
// func equal(x, y []string) bool {
// 	if len(x) != len(y) {
// 		return false
// 	}

// 	for i := range x {
// 		if x[i] != y[i] {
// 			return false
// 		}
// 	}

// 	return true
// }

// // MAKE - make()
// // Inbuilt make() takes
// // elemet type
// // len
// // cap
// // and creates a slices with the info received
// // where cap is omitted, len is used as cap
// make([]T, len)
// make([]T, len, cap) // same as make([]T, cap)[:len]
