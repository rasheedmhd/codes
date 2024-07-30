package main

import "fmt"

// Tooling
// go fmt -> formats source code to predefined Go formatting rules
// go vet -> detects syntax errors

// The Semicolon Insertion Rule
// Go compiler automatically adds ;
// if the code matches some rules like
// If the last token before a newline is any of the following, the lexer inserts a semicolon after the token:
// • An identifier (which includes words like int and float64)
// • A basic literal such as a number or string constant
// • One of the tokens: break, continue, fallthrough, return, ++, --, ), or }
func main() {
	fmt.Printf("Hello, world!")
}

// Idiomatic Go
// Just as you should run go fmt to make sure your code is formatted properly,
// run go vet to scan for possible bugs in valid code.
