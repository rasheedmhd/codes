
# Open Redirects

## Types
- Parameter-based redirects
- Referer header-based redirects
- Meta tags
- DOM `window.location`

---

## Rails-Specific Notes
When fingerprinting shows that the app is built with **Rails**,  
check to confirm whether redirects are done using:

- `_url` → appends an **absolute URL** → higher chance to redirect to a different domain
- `_path` → generates a **relative URL**

➡️ Add this note in reporting on mitigating OR if the attack surface uses Rails (or similar frameworks).  

**Tip:** Don’t use `_url` for referer-based redirects.

---

## Prevention

### URL validations
- **Allow list**
  - Check hostnames to allow only predetermined host names.
  - ⚠️ If the predetermined hostname has an open port (OP), you can chain 
  arbitrary hostnames until one that has an OP to exploit.
- **Block list**
  - Block known indicators of malicious redirects / characters often used in URL OR attacks.

**Note:** Determining hostname portions of URLs can be tricky, allowing OP to remain prevalent.
See URL parsing confusions - Semantic Gap Vulnerabilities

---

## Hunting

### Step 1: Look for Redirect Parameters
Common parameters:
- `redirect`, `redir`, `next`, `from`, `back_to`
- Use proxy and/or ZAP dir traversal
- Record all parameters used for redirection
- Search for HTTP response codes `3xx`

### Step 2: Use Google Dorks
```text
inurl:%3Dhttp site:example.com
inurl:%3D%2F site:example.com
inurl:redir site:example.com
inurl:redirect site:example.com
inurl:redirecturi site:example.com
inurl:redirect_uri site:example.com
inurl:redirecturl site:example.com
inurl:return site:example.com
inurl:returnurl site:example.com
inurl:relaystate site:example.com
inurl:forward site:example.com
inurl:forwardurl site:example.com
inurl:forward_url site:example.com
inurl:url site:example.com
inurl:uri site:example.com
inurl:dest site:example.com
inurl:destination site:example.com
inurl:next site:example.com
```

### Step 3: Test for Parameter-Based Open Redirects
Insert a random or hostname you own and see what happens
Perform action if it is required

### Step 4: Test for Referer-Based Open Redirects

### Bypassing Open-Redirect Protection
1. **Using Browser Auto correct**

2. **Exploiting Flawed Validator Logic**
> https://example.com/login?redir=https://example.com.attacker.com/example.com

3. **Using Data URLs**
Data URLs use the data: scheme to embed small files in a URL.
JavaScript code wrapped between HTML <script>
tags. It sets the location of the browser to https://example.com, 
forcing the browser to redirect there. 
You can insert this data URL into the redirection parameter to bypass blocklists:
https://example.com/login?redir=data:text/html;base64,
PHNjcmlwdD5sb2NhdGlvbj0iaHR0cHM6Ly9leGFtcGxlLmNvbSI8L3NjcmlwdD4=

4. **Exploiting URL Decoding**
When validators validate URLs, or when browsers redirect users, they have
to first find out what is contained in the URL by decoding any characters that
are URL encoded. If there is any inconsistency between how the validator and
browsers decode URLs, you could exploit that to your advantage.
- Double encode
- Non ASCII characters
- Combining Exploit Techniques
To defeat more-sophisticated URL validators, combine multiple strategies
to bypass layered defenses. I’ve found the following payload to be useful:
https://example.com%252f@attacker.com/example.com
This URL bypasses protection that checks only that a URL contains,
starts with, or ends with an allowlisted hostname by making the URL
both start and end with example.com. Most browsers will interpret example
.com%252f as the username portion of the URL. But if the validator overdecodes the URL, it will confuse example.com as the hostname portion:

➡️ Bypasses protection that only checks contains, startsWith, or endsWith hostname.

### Escalation
Open redirects can maximize the impact of vulnerabilities such as:

### SSRF
(If a site uses allowlists, attackers can abuse open redirects to escape restrictions)

### OAuth vulnerabilities

## Finding Your First Open Redirect!
1. Search for redirect URL parameters. 
2. Search for pages that perform referer-based redirects.
3. Test the pages and parameters found for open redirects.
4. If the server blocks the open redirect, try the protection bypass techniques 
5. Brainstorm ways of using the open redirect in other bug chains!

### Meta tags
HTML <meta> tags and JavaScript can redirect browsers. 
Here is what one might look like: <meta http-equiv="refresh" content="0; url=https://www.google.com/">

### DOM Redirects 
An attacker can also use JavaScript to redirect users by modifying the
window’s location property through the Document Object Model (DOM).

    window.location = https://www.google.com/
    window.location.href = https://www.google.com
    window.location.replace(https://www.google.com)

    \/yoururl.com
    \/\/yoururl.com
    \\yoururl.com
    //yoururl.com
    //theirsite@yoursite.com
    /\/yoursite.com
    https://yoursite.com%3F.theirsite.com/
    https://yoursite.com%2523.theirsite.com/
    https://yoursite?c=.theirsite.com/ (use # or \ also)
    //%2F/yoursite.com
    ////yoursite.com
    https://theirsite.computer/
    https://theirsite.com.mysite.com
    /%0D/yoursite.com (Also try %09, %00, %0a, %07)
    /%2F/yoururl.com
    /%5Cyoururl.com
    //google%E3%80%82com


Related Blog Post 
https://medium.com/@merttasci/a-little-open-redirect-bypass-story-87dde12a00a0 : Read 