# Step 2: Recon — Full Expanded Checklist

> Based on Detectify Labs: *Supercharge your hacking: Mindset, workflow, productivity and checklist*
> Fleshed out with full commands, tool usage, and explanations for every checklist item.

The recon phase starts broad and narrows down. Begin with infrastructure/asset discovery, then drill into technology analysis for every asset you find.

---

## 🔴 Large Scope (Open Scope / ASN-Level)

### ✅ Find ASNs belonging to the target

An ASN (Autonomous System Number) groups IP ranges owned by an organization. Finding them reveals infrastructure you might not know exists.

**Tools & Commands:**

```bash
# Amass — best all-in-one ASN discovery
# Too heavy: Use before taking a nap or 
# going out to touch grass
amass intel -org "Target Company Name"

# asnlookup — search by 
org name    (-d), 
ip          (-i), 
dns         (-d), 
asn         (-a), 
target list (-f)
asnmap -d target.com

# You can even do more 
asnmap -d target.com | mapcidr -silent | naabu -silent | httpx -silent

# Even more: Pipe to metabigor


# metabigor — pulls ASNs and their CIDR ranges
net - network discovery
cert - certificate transparency search 
ip - IP enrichment 
etc
[metabigor cmnds](https://github.com/j3ssie/metabigor)
echo "Target Company Name" | metabigor net --org

# BGP.he.net (manual) — go to https://bgp.he.net and search the org name
# Look at the "Networks" tab to find all IP ranges
# Get ASN from org name
curl https://api.whoxy.com/?key=xxxxx&whois=target.com
curl -s "https://api.hackertarget.com/hostsearch/?q=target.com"

# Retrieving Certificates
> openssl s_client -connect target.com:443 — does a raw TLS handshake and dumps the full certificate chain
> openssl x509 -noout -text — parses that certificate into human-readable form
openssl s_client -connect target.com:443 2>/dev/null | openssl x509 -noout -ext subjectAltName

## Basic Subdomain brute forcing
for sub in vpn api internal admin staging dev prod k8s jenkins grafana kibana consul vault; do
  dig +short $sub.ta.rget.com
done

# Then enumerate from ASN
amass intel -asn 12345 -timeout 3
```

**What to record:** ASN numbers (e.g., `AS12345`) and their associated CIDR blocks (e.g., `104.16.0.0/12`).

---

### ✅ Review acquisitions

Companies often acquire subsidiaries that fall under the same bug bounty scope but are operated under a different brand/domain.

**Steps:**
1. Go to [Crunchbase](https://www.crunchbase.com/) and click on advanced search.
2. Click the **"Acquisitions"** tab. Search the target company in the "Acquiring Company" box
3. Note every acquired company — they may have separate domains, infrastructure, and apps that are in scope.
4. Also check Wikipedia, LinkedIn, and press releases for M&A news.

**Why it matters:** Acquired companies often have older, less-hardened infrastructure with more bugs.

---

### ✅ Check registrant relationships via reverse WHOIS

WHOIS records contain the registrant's name, email, and org name. A reverse WHOIS lets you find *all* domains registered by the same person/org.

```bash
# ViewDNS Reverse WHOIS (web UI — free, limited)
# Go to: https://viewdns.info/reversewhois/
# Search by the registrant email (e.g., hostmaster@target.com) or org name

# For automation, use paid services:
# whoisxmlapi.com, domaintools.com, or SecurityTrails API

# Get registrant email from a known domain:
whois target.com | grep -i "registrant email"
# Then plug that email into ViewDNS
```

---

### ✅ Gather seed domains for further enumeration

Consolidate everything found so far into a clean seed domain list.

```bash
cat asn_domains.txt acquisitions_domains.txt whois_domains.txt | sort -u > seed_domains.txt
```

These seeds feed the medium scope checklist below.

---

## 🟡 Medium Scope (*.example.com — Subdomain Level)

### ✅ Enumerate subdomains with API-powered tools

Passive subdomain enumeration queries third-party databases (Certificate Transparency logs, DNS datasets, etc.) without touching the target directly.

```bash
# Amass — passive mode, use all configured API keys
amass enum -passive -d target.com -o amass_out.txt

# Subfinder — fastest passive tool, supports 40+ APIs
subfinder -d target.com -all -o subfinder_out.txt

# Combine and deduplicate
cat amass_out.txt subfinder_out.txt | sort -u > all_subs.txt
```

**APIs to configure** (free tiers available): Shodan, VirusTotal, SecurityTrails, Censys, Chaos (ProjectDiscovery), URLScan.io, GitHub.
Set them in `~/.config/subfinder/provider-config.yaml`.

---

### ✅ Subdomain bruteforce

Actively tries common subdomain names against the target's DNS.

```bash
# puredns — fast, accurate, handles wildcard DNS properly
puredns bruteforce wordlist.txt target.com -r resolvers.txt -o bruteforce_out.txt

# Good wordlist (2M+ entries):
# https://gist.github.com/six2dez/a307a04a222fab5a57466c51e1569acf

# Download public resolvers list:
wget https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt
```

**Wildcard tip:** puredns automatically detects and filters wildcard DNS responses, which would otherwise flood you with false positives.

---

### ✅ Discover subdomain permutations

Takes existing known subdomains and generates intelligent variations (e.g., `api.target.com` → `api-dev.target.com`, `api-staging.target.com`).

```bash
# gotator — generate permutations from your found subdomains
gotator -sub all_subs.txt -perm permutation_wordlist.txt -depth 1 -silent > perms.txt

# ripgen — faster Rust-based alternative
cat all_subs.txt | ripgen > ripgen_perms.txt

# Then resolve permutations with puredns
puredns resolve perms.txt -r resolvers.txt -o resolved_perms.txt

# Permutation wordlist:
# https://gist.github.com/six2dez/ffc2b14d283e8f8eff6ac83e20a3c4b4
```

---

### ✅ Find subdomains with HTTP ports (alive check)

Many subdomains won't respond on port 80/443. Filter for live web servers only.

```bash
# httpx — probe for live HTTP/HTTPS services
cat all_subs.txt resolved_perms.txt | sort -u | httpx -silent -o live_hosts.txt

# Also probe common non-standard ports
httpx -l all_subs.txt -ports 80,443,8080,8443,8888,3000,4443 -silent -o live_all_ports.txt
```

---

### ✅ Subdomain takeover checks

A subdomain takeover happens when a subdomain's DNS points to a third-party service (e.g., GitHub Pages, Heroku, S3) that no longer exists — anyone can claim it.

```bash
# nuclei with takeover templates
nuclei -l live_hosts.txt -t ~/nuclei-templates/takeovers/ -o takeover_results.txt

# subjack — dedicated takeover scanner
subjack -w all_subs.txt -t 100 -timeout 30 -o subjack_out.txt -ssl
```

**What to look for:** CNAME pointing to unclaimed services.
e.g., `shop.target.com CNAME target.myshopify.com` — if that Shopify store doesn't exist, takeover is possible.

---

### ✅ Shodan queries against domain

Shodan indexes internet-facing infrastructure. It can surface exposed services, open ports, and unprotected devices.

```bash
# Useful Shodan queries (web UI: https://www.shodan.io/):
ssl:"target.com"          # All certs mentioning the domain
hostname:"target.com"     # Hostnames in Shodan
org:"Target Company"      # Infrastructure by org name
net:"104.16.0.0/12"       # Scan entire ASN CIDR

# Shodan CLI:
shodan search ssl:"target.com" --fields ip_str,port,hostnames
```

**Look for:** Open databases (port 27017 MongoDB, 6379 Redis), admin panels, non-standard ports, misconfigured services.

---

### ✅ Recursively search subdomains

Run subdomain enumeration on subdomains you've already found — sometimes sub-subdomains are goldmines.

```bash
amass enum -passive -d dev.target.com -o recursive_out.txt
subfinder -d api.target.com -all -o recursive_api.txt

# Focus on: dev.*, staging.*, api.*, internal.*, vpn.*, admin.*
```

---

### ✅ Screenshots for visual inspection

Take screenshots of every live host so you can visually triage hundreds of subdomains quickly.

```bash
# gowitness — fast, modern
gowitness file -f live_hosts.txt --screenshot-path ./screenshots/

# View results as an HTML gallery
gowitness report serve

# aquatone — generates a nice HTML report automatically
cat live_hosts.txt | aquatone -out ./aquatone_report/
# Open aquatone_report/aquatone_report.html in browser
```

**What to look for visually:** Login pages, admin panels, default server pages (Apache/Nginx "Welcome" pages often mean misconfigured servers), internal tools exposed publicly.

---

## 🟢 Technology Analysis (Per-Asset Deep Dive)

Run these steps on *each* live domain you find.

---

### ✅ Identify cloud assets

Companies often expose cloud storage buckets that are publicly accessible.

```bash
# cloud_enum — searches AWS S3, Azure Blob, GCP Storage
python3 cloud_enum.py -k target -k targetcompany -k target-backup

# Also manually test:
# https://target.s3.amazonaws.com
# https://s3.amazonaws.com/target
# https://targetbackup.s3.amazonaws.com
```

---

### ✅ Identify web server, technologies, and databases

Knowing the tech stack tells you exactly which vulnerabilities and CVEs to test for.

```bash
# httpx — fingerprints tech stack from HTTP headers and body
httpx -u https://target.com -tech-detect -title -status-code -server

# whatweb — CLI alternative
whatweb https://target.com

# Wappalyzer — browser extension for visual tech detection
# Install in Chrome/Firefox, visit the target, click the icon
```

**What to record:** CMS (WordPress, Drupal), frameworks (Laravel, Rails, Django), server (Nginx, Apache, IIS), JS frameworks (React, Angular), CDN (Cloudflare, Akamai).

---

### ✅ Locate interesting files

These files often expose internal paths, API endpoints, credentials, and more.

```bash
# Check manually or with curl:
curl -s https://target.com/robots.txt
curl -s https://target.com/sitemap.xml
curl -s https://target.com/.git/HEAD        # Returns "ref: refs/..." = git repo exposed!
curl -s https://target.com/.env             # May contain DB credentials
curl -s https://target.com/crossdomain.xml
curl -s https://target.com/security.txt
curl -s https://target.com/config.php.bak

# Automate with nuclei exposures templates:
nuclei -u https://target.com -t ~/nuclei-templates/exposures/ -o exposures_out.txt
```

---

### ✅ Search comments on web pages

Developers often leave API keys, internal paths, debug info, and TODO notes in HTML/JS comments.

```bash
# In Burp Suite:
# Target → Right-click site → Engagement Tools → Find Comments

# Manual check in browser: View Page Source → Ctrl+F → search "<!--"

# CLI:
curl -s https://target.com | grep -oP '<!--.*?-->'
```

---

### ✅ Directory & parameter fuzzing

Discover hidden files, directories, and query parameters the app doesn't link to publicly.

```bash
# Directory fuzzing with ffuf
ffuf -u https://target.com/FUZZ -w /path/to/wordlist.txt -mc 200,301,302,403 -o dir_fuzz.txt

# With extensions
ffuf -u https://target.com/FUZZ -w wordlist.txt -e .php,.bak,.old,.env -mc 200,403

# Parameter fuzzing on a known endpoint
ffuf -u "https://target.com/api?FUZZ=test" -w params_wordlist.txt -mc 200

# Useful ffuf flags:
# -fc 404       → filter out 404s
# -fs 1234      → filter by response size
# -t 50         → threads
# -ac           → auto-calibrate filtering

# Wordlist (massive combined list — OneListForAll):
# https://github.com/six2dez/OneListForAll
```

---

### ✅ Identify WAFs

Knowing if a WAF is present tells you to expect blocks and to tailor your payloads to evade it.

```bash
# wafw00f — identifies WAF type
wafw00f https://target.com

# whatwaf — detects and attempts bypass techniques
python3 whatwaf -u https://target.com

# Manual check — send a clearly malicious payload:
curl -s "https://target.com/?x=<script>alert(1)</script>" -I
# 403 or redirect to a WAF error page = WAF confirmed
```

---

### ✅ Google dorking

Use Google's search operators to find sensitive information indexed from the target.

```
site:target.com filetype:pdf
site:target.com filetype:xls OR filetype:xlsx
site:target.com inurl:admin
site:target.com inurl:login
site:target.com intitle:"index of"
site:target.com "api_key" OR "api key" OR "apikey"
site:target.com ext:env OR ext:log OR ext:bak
```

Reference: [Google Hacking Database (GHDB)](https://www.exploit-db.com/google-hacking-database)

---

### ✅ GitHub dorking

Source code, API keys, credentials, and internal tooling are frequently leaked on GitHub.

```bash
# githound — automated GitHub search
githound --search-query "target.com" --results-only

# gitdorks_go — runs many dorks automatically
gitdorks_go -gd dorks.txt -org "TargetOrg" -token YOUR_GITHUB_TOKEN

# Manual GitHub search queries (go to github.com/search):
"target.com" password
"target.com" secret
"target.com" apikey
"@target.com" token
filename:.env "target.com"
filename:config.yml "target.com"
```

---

### ✅ Passive directory enumeration (Wayback / URL discovery)

Wayback Machine and similar archives have historical URLs from a target — including endpoints that no longer appear in the live app.

```bash
# waymore — queries many sources (Wayback, URLScan, AlienVault, etc.)
waymore -i target.com -mode U -oU waymore_urls.txt

# gau (Get All URLs) — queries Wayback + URLScan + Common Crawl
echo "target.com" | gau --subs --providers wayback,urlscan,otx > gau_urls.txt

# Filter for interesting endpoints:
cat waymore_urls.txt gau_urls.txt | grep -E "\.(php|asp|aspx|jsp|do|action|cfm)" | sort -u
cat waymore_urls.txt | grep "api/"
cat waymore_urls.txt | grep "admin"
```

---

### ✅ Spidering endpoints

Active crawling of the live site to find all linked pages and endpoints.

```bash
# gospider
gospider -s https://target.com -o ./spider_out/ -c 10 -d 2 --other-source --sitemap

# xnLinkFinder
python3 xnLinkFinder.py -i https://target.com -sp https://target.com -d 3 -o xnlinks_out.txt

# Combine with passive URLs:
cat gau_urls.txt spider_out/* xnlinks_out.txt | sort -u > all_urls.txt
```

---

### ✅ Check potentially vulnerable parameters

Filter discovered URLs for parameter names commonly associated with specific vulnerability classes.

```bash
# gf (grep with patterns) — pre-built regex patterns for each vuln type
cat all_urls.txt | gf xss       > xss_candidates.txt
cat all_urls.txt | gf sqli      > sqli_candidates.txt
cat all_urls.txt | gf ssrf      > ssrf_candidates.txt
cat all_urls.txt | gf lfi       > lfi_candidates.txt
cat all_urls.txt | gf redirect  > redirect_candidates.txt

# Install patterns: https://github.com/1ndianl33t/Gf-Patterns
# Common flagged params: ?redirect=, ?url=, ?page=, ?file=, ?id=, ?query=
```

---

### ✅ Locate sensitive endpoints

Manually browse through your URL list and screenshots looking for:

- Login pages: `/login`, `/signin`, `/admin/login`, `/wp-login.php`
- Admin panels: `/admin`, `/administrator`, `/dashboard`, `/manage`, `/console`
- API endpoints: `/api/v1`, `/graphql`, `/swagger`, `/api-docs`
- Internal tools: `/internal`, `/staff`, `/backend`

```bash
# Quick grep through all discovered URLs:
cat all_urls.txt | grep -iE "(login|admin|dashboard|console|manage|staff|internal|graphql|swagger)"
```

---

### ✅ Get all JS files

JavaScript files frequently contain hardcoded API endpoints, authentication logic, internal paths, and secrets.

```bash
# subjs — extracts JS file URLs from a host
echo "https://target.com" | subjs | tee js_files.txt

# Download all JS files for local analysis:
mkdir js_downloaded
while read url; do
  curl -s "$url" -o "js_downloaded/$(echo $url | md5sum | cut -d' ' -f1).js"
done < js_files.txt
```

---

### ✅ JS hardcoded APIs and secrets

Search downloaded JS files for accidentally committed secrets.

```bash
# nuclei token templates
nuclei -l js_files.txt -t ~/nuclei-templates/exposures/tokens/ -o js_secrets.txt

# trufflehog — entropy-based secret scanning
trufflehog filesystem ./js_downloaded/ --json

# Manual grep:
grep -rE "(api_key|apikey|api-key|secret|token|password|passwd|auth|credential)" ./js_downloaded/
grep -rE "[A-Za-z0-9]{32,}" ./js_downloaded/   # Long random strings = likely secrets
```

---

### ✅ JS analysis (endpoint extraction)

Extract hidden API endpoints and function names from JS files.

```bash
# JSA (JS Analyser)
python3 jsa.py -i js_files.txt -o jsa_results.txt

# getjswords — extracts interesting words/paths from JS
python3 getjswords.py -i js_files.txt

# xnLinkFinder against JS files
python3 xnLinkFinder.py -i js_files.txt -o js_endpoints.txt

# Add discovered endpoints to master URL list:
cat jsa_results.txt js_endpoints.txt | sort -u >> all_urls.txt
```

---

### ✅ Run automated scanner (nuclei)

Nuclei runs hundreds of community-written templates covering CVEs, misconfigurations, exposed panels, and more.

```bash
# Full scan against a single target
nuclei -u https://target.com -t ~/nuclei-templates/ -severity low,medium,high,critical -o nuclei_results.txt

# Against all live hosts
nuclei -l live_hosts.txt -t ~/nuclei-templates/ -o nuclei_all_hosts.txt

# Useful flags:
# -as          → automatic scan (smart tag selection)
# -rl 50       → rate limit (requests per second)
# -c 25        → concurrency
# -retries 2   → retry failed requests
```

---

### ✅ Test CORS

Misconfigured CORS can allow any website to read authenticated responses from the API on behalf of the victim.

```bash
# CORScanner
python3 cors_scan.py -u https://target.com/api/user -v

# corsy — tests all endpoints from a list
python3 corsy.py -i live_hosts.txt -t 10 -o corsy_results.txt

# Manual test in Burp Suite:
# Add header: Origin: https://evil.com
# Check if response includes:
#   Access-Control-Allow-Origin: https://evil.com
#   Access-Control-Allow-Credentials: true
# If both → high severity CORS misconfiguration
```

---

## 🗂️ Suggested Output File Structure

Keep everything organized as you go:

```
recon/
├── asns.txt
├── seed_domains.txt
├── all_subs.txt
├── live_hosts.txt
├── screenshots/
├── all_urls.txt
├── js_files.txt
├── js_downloaded/
├── nuclei_results.txt
├── vuln_candidates/
│   ├── xss.txt
│   ├── sqli.txt
│   ├── ssrf.txt
│   └── lfi.txt
└── notes.md
```

---

## 🔗 Key Tools Reference

| Tool | Purpose | Link |
|---|---|---|
| Amass | ASN + subdomain enum | https://github.com/OWASP/Amass |
| Subfinder | Passive subdomain enum | https://github.com/projectdiscovery/subfinder |
| puredns | Subdomain bruteforce + resolve | https://github.com/d3mondev/puredns |
| gotator | Subdomain permutations | https://github.com/Josue87/gotator |
| httpx | HTTP probing + tech detect | https://github.com/projectdiscovery/httpx |
| nuclei | Automated vuln scanning | https://github.com/projectdiscovery/nuclei |
| gowitness | Screenshots | https://github.com/sensepost/gowitness |
| ffuf | Dir + param fuzzing | https://github.com/ffuf/ffuf |
| wafw00f | WAF detection | https://github.com/EnableSecurity/wafw00f |
| gospider | Web spidering | https://github.com/jaeles-project/gospider |
| gau | Passive URL discovery | https://github.com/lc/gau |
| waymore | Passive URL discovery (more sources) | https://github.com/xnl-h4ck3r/waymore |
| trufflehog | Secret scanning in JS/files | https://github.com/trufflesecurity/trufflehog |
| corsy | CORS misconfiguration testing | https://github.com/s0md3v/Corsy |
| gf | Vuln parameter grep patterns | https://github.com/1ndianl33t/Gf-Patterns |
| subjs | JS file extraction | https://github.com/lc/subjs |
| subjack | Subdomain takeover | https://github.com/haccer/subjack |
| cloud_enum | Cloud asset discovery | https://github.com/initstring/cloud_enum |
