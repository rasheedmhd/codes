# Carriage Return (\n) Line Feed (\r) Injection 
Originates where browsers fail to sanitize special characters and  
send them to the server which interprets them at the OS level

HTTP is a plaintext protocol that uses Carriage Return(\r) Line Feed(\n)
characters to delimiter headers. When user input in HTTP headers lands in the
response headers from the server, one can inject CRLF within headers that they 
have full or partial control of their values to achieve client-side attacks. 

# Response Splitting
This is when one abusing their control of a header value to coerce server to 
return two responses for one request by hiding the second response within the 
request to the server. The server thinks it is sending a response to the client
unbeknownst to it, it is also reflecting another response that was injected by an attacker

## Request 
GET / HTTP/1.1
Host: example
Header-We-Control: x%0D%0A%0D%0A<script>alert(origin)</script>

## Response
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 36
Header-We-Control: x---------------------
                                        |
<script>alert(origin)</script>          |------------- Injected Response 
-----------------------------------------

<body>This is the normal body</body>

## Splitting JSON Response
We can overwrite the correct content type with our malicious content type
using the CRLF injection

## Request 
GET / HTTP/1.1
Host: example
Header-We-Control: x%0D%0AContent-Type:%20text/html%0D%0A%0D%0A%3Cscript%3Ealert(origin)%3C/script%3E

## Response
HTTP/1.1 200 OK
Content-Type: application/json
Header-We-Control: x---------------------
Content-Type: text/html                 |
                                        |
<script>alert(origin)</script>          |------------- Injected Response 
-----------------------------------------

{"some": "json"}

[See More](https://gist.github.com/avlidienbrunn/8db7f692404cdd3c325aa20d09437e13)

# Content-Security-Policy (CSP)
A CSP may be in effect on the resulting page if it comes before your injection point. 
[TODO: See CSP BYPASSES]

# Causes 
Forgetfulness
Improper Sanitation of special characters
Interpreting backward compatible HTTP/0.9 and HTTP/1.1

    %OD %0A 
    \r  \n

# CRLFs can lead to 
## HTTP request smuggling
- Where one is able to add another request to the initial legit request 
!= Parameter pollution bc HPP duplicates req parameters != full requests

Exploiting it can lead to 
1. Cache poisoning, - modify app caches to arbitrary pages and 
return illegitimate pages when the right pages are requested 
2. Firewall by pass/evasion, 
Request hijacking - stealing `httponly` cookies and 
HTTP authentication information with no interaction between the attacker and client. 

## HTTP response splitting
Allows an attacker to split a single HTTP response by injecting new headers that browsers interpret.

[PracticalCTF](https://book.jorianwoltjer.com/web/client-side/crlf-header-injection)
[OFFZONE 23](https://web.archive.org/web/20230910071957/https://offzone.moscow/upload/iblock/11a/sagouc86idiapdb8f29w41yaupqv6fwv.pdf)
[Detectify](https://blog.detectify.com/industry-insights/http-response-splitting-exploitations-and-mitigations/)