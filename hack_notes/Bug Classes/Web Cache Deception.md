# Web Caches + CDNS 

# Cache keys

# cache Busters 

# URL discrepancies 
## Delimiters
Spring           ;         Semicolon
Rails            .         Dot
OpenLiteSpeed    %00       Null encoded byte
Nginx            %0a       New line encoded byte

[Modern Technology Delimiters](https://medium.com/@0xAwali/http-parameter-pollution-in-2024-32ec1b810f89)

# Terminology
Origin Server : The server that serves the content AKA Backend server
Cache Proxy   : The server that caches the content AKA Frontend server
Load Balancer : The server that distributes the traffic to the origin server
Delimiter     : A character or string that separates the path from the query string [see more explanation below]

# Detecting Origin Delimiters 
1. Identify a `non-cacheable` request 
In this case we hope that what is appended is ignored by the frontend server and makes it to the origin server.
2. Send the same request appending a random suffix at the end of the path 
> abc / ? # % ; %2F %00 %0a %09 %20 %3B 
> %3Fname=valnonexistent.css
[Concept of a Path Parameter](Cached and Confused) : /<random>.css
3. Send the same request appending a delimiter before the random suffix at the end of the path 
> abc / ? # % ; %2F %00 %0a %09 %20 %3B
> %3Fname=valnonexistent.css
If the responses are identical, the character or string is used as a delimiter.
Use Burp Intruder 
## & = URL delimiter in the real world (URL RFCs)
## CVE from web framework(bottle) using ; as delimiter 
[Python Bottle delimiter](https://security.snyk.io/vuln/SNYK-PYTHON-BOTTLE-1017108)
[Open Source Packages](https://snyk.io/blog/cache-poisoning-in-popular-open-source-packages)
[Fix in code](https://github.com/python/cpython/blob/main/Lib/urllib/parse.py#L739)

What does a `delimiter` mean or does exactly? 
The delimiter is a character, that when the url parser reaches it,
a logical stop in parsing is decided there whatever character/s that follows
that character is considered as not part of the URL path

# Why is this Important? 
Identifying and using the delimiter allows to essentially coerce the parser to stop parsing at an 
arbitrary section of the URL that we want. 
See where this is going? Meaning we can smuggle a payload to the other URL parser or pass the cache server. 
In this case we are talking about the Origin Server i.e the application server or servers like nginx, apache, 
etc not the cache servers like cloudflare, etc.

# Detecting Cache Delimiters 
Cache servers often don't use delimiters aside from `?`
1. Identify cacheable request
Because it is a cacheable request, we can be sure that at least the cache server will pay attention to it, parse it. 
2. Send same req with a potential delimiter and compare the response
> abc / ? # % 
> GET /static-endpoint<DELIMITER><Random>

# Normalization
URL parsers are used by both the cache and origin server to extract paths for endpoint mapping,
cache keys, and rules. First, `path delimiters` are identified to locate the start and end of the
pathname. Once the path is extracted, it's normalized to its absolute form by decoding characters
and removing `dot-segments`

# Encoding 
Sometimes, a `delimiter character` needs to be sent for interpretation by the application rather than
the HTTP parser. For such cases, the URI RFC defines URL encoding, which allows characters to
be encoded to avoid modifying the meaning of the pathname.

# Detecting decoding behaviors
To test if a character is being decoded, compare a base request with its encoded version.
Encode chars individually
Example:
> /home/index → /%68%6f%6d%65%2f%69%6e%64%65%78

# Dot-segment normalization
It's possible to exploit `dot-segment normalization` by leveraging the discrepancies between parsers
to modify the behavior of the cache rules and obtain crafted keys. 

# Detecting dot-segment normalization
To detect normalization in the origin server, issue a non-cacheable request (or a request with a
cache buster) to a known path, then send the same message with a path traversal sequence:
> GET /home/index?cacheBuster=donotpoisoneveryone
> GET /aaa/../home/index?cacheBuster=donotpoisoneveryone or 
> GET /aaa%2F..%2Fhome/index?cacheBuster=donotpoisoneveryone or 
> GET /aaa\..\home/index?cacheBuster=donotpoisoneveryone

# Normalization discrepancies
The following tables illustrate how different HTTP servers and web cache proxies normalize the
path `/hello/..%2Fworld`. Some resolve the path to /world, while others don't normalize it at all.
TO DO

# Exploiting Web Cache Deception 
## Static file extensions / URL Mapping discrepancies
This is where the cache rule says the proxy should cache all files that ends with one of 
the static extensions it supports 
Here you add `/test.js : A /(sometimes encoded) a random string(test) and a static file extension(.js)`
Refer to the proxy static file extensions list 
[Cloudflare default Cache File extensions](https://developers.cloudflare.com/cache/concepts/default-cache-behavior/#default-cached-file-extensions)

# How/Why it happens 
Here we are assuming that the Origin Server's delimiter is a `$/#` 
and the cached file extensions the proxy supports is a `.css`
Proxy sees and pays attention to `a.css`
Server sees and ignores `a.css`
Cache Proxy                   Origin Server
> /myAccount$a.css            /myAccount$a.css
> /myAccount%23a.css          /myAccount#a.css 

Sometimes the Cache Proxy/LB/Frontend Server decodes the URL before forwarding to the Origin Server
A this point you should be aware of which components behaves in which ways based on
prior research probes in detecting path normalization 
Load Balancer:              /myAccount%25%32%33a.css 
Cache Proxy:                /myAccount%23a.css  
Origin Server:              /myAccount#a.css 
If you are sending # in the browser, you need to encode it. Browsers don't send fragments to servers

# Weaponizing Intermediary decoding/normalization
Prerequisite: Intermediary decoding/normalization 
Ex: Browsers won't send #<whatever> to the server but will
happily send $23<whatever> to the server 
TODO - see gotta cache'em all p9

# Static directories
Eg: Where to find them
Tip: Check your browser network tap for cached files/request responses.
```
/static
/assets
/wp-content
/media
/templates
/public
/shared
```

# Exploiting static directories with delimiters
Prerequisites: 
1. Origin Only recognized delimiter
2. Cache normalization 
3. Static routes caching rule in place
If a char is used as a `delimiter` by the Origin Server but not by the cache server and the 
cache server normalizes the path before applying a static directory rule, 
you can hide a path traversal segment after the `delimiter`, which the cache will resolve:

> GET /<DynamicResource><OriginOnlyDelimiter><EncodedDotSegment><StaticDirectory>
CP normalizes req, applying the path traversal so it sees `/static/any` 
Origin Server uses `$` as `delimiter` so it ignores `$/..%2Fstatic/any` and serves `/myAccount`
CP applying static directory rules caches `/myAccount` as `/static/any` 
Browser                          Cache Proxy      Origin Server
> /myAccount$/..%2Fstatic/any    /static/any      /myAccount

Remember to test the behavior of the CP 
Tip: Which CP does normalization? refer to the CP normalization table 
so you can make an educated guess before you start testing 
1. CloudFront
2. Microsoft Azure 
3. Imperva

# Exploiting static directories through Backend only normalization
Prerequisites:
1. Origin Server normalizes path
2. Cache Server doesn't normalize path
3. Static routes caching rule in place
The Origin Server normalizes the path before mapping the endpoint but the 
cache doesn't normalize the path before evaluating the cache rules, 
You can add a path traversal segment that will only be processed by the Origin Server:

GET /<StaticDirectory><EncodedDotSegment><DynamicResource>
CP doesn't normalize encoding, forwards to Origin Server
Origin Server normalizes path traversal dot segments and serves `/myAccount` 
CP caches response thinking it is under `/static/`
Browser                   Cache Proxy                 Origin Server
> /static/..%2FmyAccount  /static/..%2FmyAccount      /myAccount

Remember to test the behavior of the CP 
Tip: Which CP does normalization? refer to the CP normalization table 
so you can make an educated guess before you start testing 
Cache Proxies that don't Normalize paths  
1. Cloudflare
2. Google Cloud
3. Fastly 
Origin Server that Normalize paths
1. Nginx
2. Microsoft IIS 
3. OpenLiteSpeed

TO DO
Create an extended table of cache + origin -> wcd (Vulnerable Combinations)
Can be fed to the algorithm detection modules
Note: A normalization discrepancy arises when combining Microsoft IIS with 
any web cache that doesn't convert backlashes
> /static/..%5CmyAccount /static/..\myAccount → /myAccount 

# Real world Exploit normalization
https://nokline.github.io/bugbounty/2024/02/04/ChatGPT-ATO.html
%2F..%2F

# Static files
Files, like /robots.txt, /favicon.ico, and /index.html, 

# Exploiting static files
Prerequisites:
1. Cache Server normalize path
2. Origin Server doesn't normalizes path
3. Static file caching rule in place
4. Origin Only delimiter
Use the technique used in static directories where
the CP normalizes the req and there is a delimiter at the backend. 
The static directory is replaced by the filename and a cache buster

> GET /<DynamicResource><OriginOnlyDelimiter><EncodedDotSegment><Static_File>
Request                         Cache Proxy ses     Origin Server sees
> /myAccount/..%2Frobots.txt    /robots.txt         /myAccount


# Understanding Our Cache and the Web Cache Deception Attack
https://blog.cloudflare.com/understanding-our-cache-and-the-web-cache-deception-attack/
Web cache deception lab delimiter list
```
!
"
#
$
%
&
'
(
)
*
+
,
-
.
/
:
;
<
=
>
?
@
[
\
]
^
_
`
{
|
}
~
%00
%0A
%09
%21
%22
%23
%24
%25
%26
%27
%28
%29
%2A
%2B
%2C
%2D
%2E
%2F
%3A
%3B
%3C
%3D
%3E
%3F
%40
%5B
%5C
%5D
%5E
%5F
%60
%7B
%7C
%7D
%7E 


Cloudflare Default static file extensions
7Z  
CSV  
GIF  
MIDI  
PNG  
TIF  
ZIP  
AVI  
DOC  
GZ  
MKV  
PPT  
TIFF  
ZST  
AVIF  
DOCX  
ICO  
MP3  
PPTX  
TTF  
APK  
DMG  
ISO  
MP4  
PS  
WEBM  
BIN  
EJS  
JAR  
OGG  
RAR  
WEBP  
BMP  
EOT  
JPG  
OTF  
SVG  
WOFF  
BZ2  
EPS  
JPEG  
PDF  
SVGZ  
WOFF2  
CLASS  
EXE  
JS  
PICT  
SWF  
XLS  
CSS  
FLAC  
MID  
PLS  
TAR  
XLSX  
```

# Real world exploits
https://hackerone.com/reports/631589
https://zhero-web-sec.github.io/cache-deception-to-csrf/

# Report Sample 
Web Cache Deception
Web cache deception is a vulnerability that enables an attacker to trick a web cache into storing sensitive, dynamic content. It's caused by discrepancies between how the cache server and origin server handle requests.
In a web cache deception attack, an attacker persuades a victim to visit a malicious URL, inducing the victim's browser to make an ambiguous request for sensitive content. The cache misinterprets this as a request for a static resource and stores the response. The attacker can then request the same URL to access the cached response, gaining unauthorized access to private information.
Websites often tend to use web cache functionality with CDNs to store files(mostly static) that are often retrieved, to reduce latency from the web server. For example let's say http://www.example.com is configured to go cache some files on a CDN. A dynamic page that is stored on the server and returns personal content of users, such as http://www.example.com/home.php, will have to created dynamically per user, since the data is different for each user. This kind of data, or at least its personalized parts, isn't cached.
As said above what is commonly cached and reasonably so are static, public files: style sheets (css), scripts (js), text files (txt), images (png, bmp, gif), etc. This makes sense because these files usually don't contain any sensitive information and don't change too often. It's a widely recommended practice to cache all static files that are meant to be public.
What happens when accessing a URL like http://www.example.com/home.php/random_might_not_even_exist.css ? The browser makes a GET request to that URL. How does the server interpret the request URL? The server returns the content of http://www.example.com/home.php. And yes, the URL remains http://www.example.com/home.php/random_might_not_even_exist.css. The HTTP headers will be the same as for accessing http://www.example.com/home.php directly: same caching headers and same content type (text/html, in this case).
As stated prior http://www.example.com/home.php has dynamic and sensitive information and it is not supposed to be cached. But now we have appended a file that might not even exist to insinuate to the Web Server that we want to get that file and because the GET request has to pass through the CDN first, and the URL matches the CDN's rules of caching static files, On the first request http://www.example.com/home.php/random_might_not_even_exist.css isn't cached so the request is forwarded to the Server that returns http://www.example.com/home.php as http://www.example.com/home.php/random_might_not_even_exist.css and the CDN caches
http://www.example.com/home.php/random_might_not_even_exist.css. Now anyone even unauthenticated can visit http://www.example.com/home.php/random_might_not_even_exist.css anywhere and they will see the victim's information at http://www.example.com/home.php/random_might_not_even_exist.css. Information that was only supposed to be available at http://www.example.com/home.php for the authenticated user/victim.


## Summary of the Issue
The web application is vulnerable to a cache poisoning issue on the following endpoint:
 
```
https://
```
 
The responses to GET requests are being served from a public cache, however due to the lack of the request body being present in the cache keys, we can achieve <insert vulnerability> via the <parameter_name> parameter of our requests.
 
## Steps to reproduce
 
1. Open Burp Suite and ensure it's sniffing all HTTP(S) requests in the background.
2. Navigate to <endpoint>. Find the request to this endpoint in Burp's proxy history and send it to the repeater.
3. Add the following cachebuster as a GET parameter: 'dontpoison=true'. This will ensure to isolate the resulting exploit to users who make requests to this endpoint with the 'dontpoison' parameter & value pair present.
4. Insert the following POST parameter and value to the request body:
 
<param> = <value>
 
The entire request should now look like:
 
<Full HTTP Request>
 
5. Submit the request 8-10 times. Remove the POST parameter and value pair that was added in the previous step. 
6. Change your IP address, and submit the request again. As you can see, the exploit has persisted, showing caching poisoning.
  
## Impact statement
An attacker can poison the response served from the public cache to all users who navigate to the affected endpoint, resulting in <vulnerability name>
 
## Remediation
 
Ensure that the application does not process the HTTP body of a GET request.