package main

import (
	"crypto/sha256"
	"fmt"
)

func main() {
	c1 := sha256.Sum256([]byte("x"))
	c2 := sha256.Sum256([]byte("X"))
	fmt.Printf("%x\n%x\n%t\n%T\n", c1, c2, c1 == c2, c1)
	// Output:
	// 2d711642b726b04401627ca9fbac32f5c8530fb1903cc4db02258717921a4881
	// 4b68ab3847feda7d6c62c1fbcbeebfa35eab7351ed5e78f4ddadea5df64b8015
	// false
	// [32]uint8
	// &x = prints elements of an array
	// &t = prints a boolean results
	// &T = prints the type of a value
	//
	// Go treats ARRAYS as pass-by-value
	// https://www.ibm.com/docs/en/zos/2.4.0?topic=calls-pass-by-value
	// Uses pointers for pass-by-reference
	b := [32]byte{}
	for i := 0; i < 32; i++ {
		b[i] = byte(i + 1)
	}
	zero(&b)
}

func zero(ptr *[32]byte) {
	fmt.Print("&x", ptr)
	for i := range ptr {
		ptr[i] = 0
	}
	fmt.Print("&x", ptr)
}
