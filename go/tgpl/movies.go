package main

// Make cre
import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	movies := make(map[int]string)
	url := os.Args[1:]
	for num := 0; num < 100; num++ {
		// fqu =
		resp, err := http.Get("%s/%d", url, num)
		if err != nil {
			fmt.Print("An error occured getting url")
		}

	}

}
