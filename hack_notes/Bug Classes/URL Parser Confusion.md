# Categories
1. Scheme
2. Slash
3. BackSlash 
4. URL Encoded confusion 

# The Mechanism of Schema confusion
Some URL parsers get confused when the scheme component is omitted. Why ? because they follow RFC 3986
which clearly determines that the only mandatory part of the URL is the scheme, whereas previous RFC releases (RFC 2396 and
earlier) don’t specify it. Therefore, the parsers are designed with the assumption that for a valid URL, 
a scheme must be present and when it is not present, most parsers get confused.

# The Mechanism of Slash confusion
Happens when a non-RFC compliant number of // are encountered in a URL specifically at the authority
As written in RFC 3986, a URL authority should start after the scheme, separated by a colon and two forward slashes ://.
It should persist until either the parser reaches the end of a line (EOL) or a delimiter is read; these delimiters being
either a slash signaling the start of a path component, a question mark signaling the start of a query, or a hashtag
signaling a fragment.

As we’ve seen before, because urlsplit does not ignore extra slashes, it will parse this URL as a URL with an empty authority
(netloc), thus passing the security check comparing the netloc (an empty string in this case) to google.com. However, since
cURL ignores the extra slash, it will fetch the URL as if it had only two slashes, thus bypassing the attempted validation and
resulting in a SSRF vulnerability.

# BackSlash confusion Mechanism
According to RFC 3986, a backslash is an entirely different character from a slash, and should not be interpreted
as one. This means the URL https://google.com and https:\\google.com are different and should be parsed differently.
And true to the RFC, most programmatic URL parsers do not treat a slash and a backslash interchangeably:

# URL-ENCODED DATA CONFUSION
According to the URL RFC (RFC 3986), all URL components except the scheme can be represented using URL encoded
characters, and when parsed should be URL decoded.
This dissonance in which one time the parser decodes the URL and another it does not opens a huge range of possible
vulnerabilities in which an attacker could bypass validations being performed by URL-decoding the URL he wants to
retrieve

# SCHEME MIXUP
The scheme component of a URL dictates the exact URL protocol which should be used in order to
parse the URL. 

# Resources 
https://blog.bugport.net/exploiting-http-parsers-inconsistencies