// package main

// import (
// 	"encoding/json"
// 	"fmt"
// 	"log"
// )

// // That’s b e c aus e of t he field tag s.
// // A field t ag is a st r ing of met ad at a associated at compile time with the field of a struct:

// type Movie struct {
// 	Title  string
// 	Year   int  `json:"released"`
// 	Color  bool `json:"color,omitempty"`
// 	Actors []string
// }

// func main() {
// 	var movies = []Movie{
// 		{Title: "Casablanca", Year: 1942, Color: false,
// 			Actors: []string{"Humphrey Bogart", "Ingrid Bergman"}},
// 		{Title: "Cool Hand Luke", Year: 1967, Color: true,
// 			Actors: []string{"Paul Newman"}},
// 		{Title: "Bullitt", Year: 1968, Color: true,
// 			Actors: []string{"Steve McQueen", "Jacqueline Bisset"}},
// 		// ...
// 	}
// 	// data, err := json.Marshal(movies)
// 	// For human consumption, a variant called json.MarshalIndent
// 	// produces neatly indented output.
// 	data, err := json.MarshalIndent(movies, "", "    ")
// 	if err != nil {
// 		log.Fatalf("JSON marshaling failed: %s", err)
// 	}
// 	fmt.Printf("%s\n", data)

// 	// Unmarshalling
// 	// Parsing JSON into Go data structures
// 	var titles []struct{ Title string }
// 	if err := json.Unmarshal(data, &titles); err != nil {
// 		log.Fatalf("JSON unmarshaling failed: %s", err)
// 	}
// 	fmt.Println(titles) // "[{Casablanca} {Cool Hand Luke} {Bullitt}]"
// }
