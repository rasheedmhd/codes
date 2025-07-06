package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	host := r.Host
	fmt.Fprintf(w, "<h1>Host Header</h1><p>%s</p>", host)
}

func main() {
	http.HandleFunc("/", handler)

	fmt.Println("Server running on http://localhost:8080")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		panic(err)
	}
}

