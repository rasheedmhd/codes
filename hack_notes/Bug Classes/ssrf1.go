package main

import (
	"encoding/hex"
	"fmt"
	"io/ioutil"
	"net/http"
)

// secretServer mimics an internal service that returns sensitive
// credentials.
type secretServer struct {
}

// ListenAndServe will start an HTTP server and bind to 127.0.0.1:8081.
func (s *secretServer) ListenAndServe() error {
	server := &http.Server{
		Addr:    "127.0.0.1:8081",
		Handler: http.HandlerFunc(s.handler),
	}
	return server.ListenAndServe()
}

// handler returns sensitive credentials that only internal applications
// should have access to.
func (s *secretServer) handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "SECRET_CREDENTIALS")
}

// applicationServer is the public facing service that returns a hex
// dump of the requested URL.
type applicationServer struct {
}

// ListenAndServe will start an HTTP server and bind to :8080.
func (s *applicationServer) ListenAndServe() error {
	server := &http.Server{
		Addr:    ":8080",
		Handler: http.HandlerFunc(s.handler),
	}
	return server.ListenAndServe()
}

// handler returns a hexdump of the request URL passed in as a query parameter.
func (s *applicationServer) handler(w http.ResponseWriter, r *http.Request) {
	// Extract the URL from the query parameters.
	urls, ok := r.URL.Query()["url"]
	if !ok {
		http.Error(w, "url missing", 500)
		return
	}
	if len(urls) != 1 {
		http.Error(w, "url missing", 500)
		return
	}

	// Fetch the requested URL.
	resp, err := http.Get(urls[0])
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	defer resp.Body.Close()

	// Read in the response body.
	bytes, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	// Write out the hexdump of the bytes as plaintext.
	w.Header().Set("Content-Type", "text/plain; charset=utf-8")
	fmt.Fprint(w, hex.Dump(bytes))
}

func main() {
	// Start the secret service.
	var ss *secretServer
	go ss.ListenAndServe()

	// Start the application service.
	var as *applicationServer
	as.ListenAndServe()
}
