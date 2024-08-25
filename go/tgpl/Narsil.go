package main

// Make cre
import (
	"fmt"
	"net/http"
	"os"
)

func main() {

	movies := make(map[int]string)
	url := os.Args[1]

	for num := 0; num < 1000; num++ {
		fqu := url + string(num)
		resp, err := http.Get(fqu)
		if err != nil {
			fmt.Print("An error occured getting url")
			fmt.Fprintf(os.Stderr, "Narsil: %v\n", err)
			os.Exit(1)
		}
		movie := retriveTitle(resp)
		movies[num] = movie
	}

}

// a function that parses the returned body to get the title of the movie
func retriveTitle(resp *http.Response) string {
	//
	return "H"
}
