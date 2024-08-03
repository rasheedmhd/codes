// Echo prints its command line arguments
package main

import (
	"fmt"
	"os"
)

func main() {
	var s, sep string
	for i := 0; i < len(os.Args); i++ {
		s += sep + os.Args[i]
		sep = " "
	}
	fmt.Println(s)
}

// Exercise 1
// func main() {
// 	for i, arg := range os.Args[1:] {
// 		fmt.Println(i, arg)
// 	}
// }

// other forms of Go for
// for condition {} -> traditional while loop
// for {} -> traditional infinite loop. Can end with return/break
// for on ranges
// for _, arg := os.Args[1:] {}

// String method -> Join
// strings.Join(os.Args[1:], " ")
