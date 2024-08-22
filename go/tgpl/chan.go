package main

import (
	"encoding/json"
	"fmt"
)

// import "fmt"

// func strlen(s string, c chan int) {
// 	c <- len(s)
// }

//	func main() {
//		c := make(chan int)
//		go strlen("Hello", c)
//		go strlen("World!", c)
//		x, y := <-c, <-c
//		fmt.Println(x, y, x+y)
//	}
type Foo struct {
	Bar string
	Baz string
}

func main() {
	f := Foo{"Joe Junior", "Hello Shabado"}
	b, _ := json.Marshal(f)
	fmt.Println(string(b))
	json.Unmarshal(b, &f)
}
