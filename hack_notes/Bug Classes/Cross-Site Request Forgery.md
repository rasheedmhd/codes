# Cross-Site Request Forgery
Manipulating browsers to make state changing request on victims behalf.

# Protections
- CSRF Tokens (set my web frameworks like rails/django)
- SameSite header settings (cookies) Strict/Lax/None + HttpOnly
prevent sending cookies on POST, AJAX and iframes
set Lax by some browsers like chromes

## Caveats:
- When browsers allow state-changing req with GET, CSRF becomes easier 
- Some websites needs cross site cookie sending to work so they manually set SameSite to None
- Exploit browsers without default SameSite settings set

# HUNTING
**Keep an eye out for HTTP requests that perform some action on the server**
1. Spot state changing actions
2. Look for a Lack of CSRF Protections
3. Confirm the Vulnerability

> GET requests should never be allowed to modify any data on the server. 

# CORS 
Preflight request 
application/json
samesite lax/strict/

# Bypassing CSRF Protection
1. Through clickjacking
2. Changing the Request Method
Sometimes sites will accept multiple request methods for the same endpoint, 
but protection might not be in place for each of those methods.
Change the req method and submit the req without the CSRF token

## Bypass CSRF Tokens Stored on the Server
Websites can use CSRF tokens without proper validation

    <html>
      <!-- blank csrf value -->
      <form method="POST" action="https://email.example.com/password_change" id="csrf-form">
        <input type="text" name="new_password" value="abc123">
        <input type="text" name="csrf_token" value=""> 
        <input type='submit' value="Submit">
      </form>
      <script>document.getElementById("csrf-form").submit();</script>
    </html>

    <iframe style="display:none" name="csrf-frame"></iframe>
    <form method='POST' action='http://bank.com/transfer' target="csrf-frame" id="csrf-form">
      <input type='hidden' name='from' value='Bob'>
      <input type='hidden' name='to' value='Joe'>
      <input type='hidden' name='amount' value='500'>
      <input type='submit' value='submit'>
    </form>
    <script>document.getElementById("csrf-form").submit()</script>

Sending blank tokens is worth trying because sometimes validation only get called
when the token exist or isn't blank

3. Bypass Double-Submit CSRF Tokens
Here a CSRF is sent in the cookie and as a Request Header, the 
backend checks to see if that order (the same token in cookie and header) 
has been maintained else rejects the request.
Session fixation can help with spoofing the cookie value
https://en.wikipedia.org/wiki/Session_fixation

4. Bypass CSRF Referer Header Check
But how do you know if the server relies on referer header?
- Remove the referer header
```
<html>
  <meta name="referrer" content="no-referrer">
  <form method="POST" action="https://email.example.com/password_change" id="csrf-form">
    <input type="text" name="new_password" value="abc123">
    <input type='submit' value="Submit">
  </form>
  <script>document.getElementById("csrf-form").submit();</script>
</html>
```

5. Bypass CSRF Protection by Using XSS
XSS will allow attackers to steal the legitimate
CSRF token and then craft forged requests by using XMLHttpRequest

# Escalating the Attack
1. Leak User Information by Using CSRF
2. Create Stored Self-XSS by Using CSRF
3. Take Over User Accounts by Using CSRF
If a user signed up via their social media account, they don’t need
to provide an old password to set the new password, so if CSRF protection
fails on this endpoint, an attacker would have the ability to set a password for
anyone who signed up via their social media account and hasn’t yet done so.

# Delivering the CSRF Payload
1. Get users to click a link to a page
2. The page has an auto submitting form
3. For CSRFs that you could execute via a GET request, embed the request as an image directly
<img src="https://email.example.com/set_password?new_password=this_account_is_now_mine"/>
4. deliver a CSRF payload to a large audience by exploiting stored XSS


# Real World Reports
[Shopify Twitter Disconnect](https://hackerone.com/reports/111216)
[Badoo CSRF to Account TakeOver](https://hackerone.com/reports/127703/)

    POC
    <html>
    <body>
    <img src="https://twitter-commerce.shopifyapps.com/auth/twitter/disconnect">
      </body>
    </html>

# Finding Your First CSRF!

1. Spot the state-changing actions on the application and keep a note on
their locations and functionality.
2. Check these functionalities for CSRF protection. 
If you can’t spot any protections, you might have found a vulnerability!
3. If any CSRF protection mechanisms are present, try to bypass the protection
4. Confirm the vulnerability by crafting a malicious HTML page and visiting that page to see if the action has executed.
5. Think of strategies for delivering your payload to end users.
6. Draft your first CSRF report!


# CSRF Filter Bypass

    \/yoururl.com
    \/\/yoururl.com
    \\yoururl.com
    //yoururl.com
    //theirsite@yoursite.com
    /\/yoursite.com
    https://yoursite.com%3F.theirsite.com/
    https://yoursite.com%2523.theirsite.com/
    https://yoursite?c=.theirsite.com/ (use # \ also)
    //%2F/yoursite.com
    ////yoursite.com
    https://theirsite.computer/
    https://theirsite.com.mysite.com
    /%0D/yoursite.com (Also try %09, %00, %0a, %07)
    /%2F/yoururl.com
    /%5Cyoururl.com
    //google%E3%80%82com


From https://whitton.io/articles/messenger-site-wide-csrf/
The way I normally check for these is as follows:

1 Perform the request without modifying the parameters, so we can see what the expected result is
2 Remove the CSRF token completely (in this case, the fb_dtsg parameter)
3 Modify one of the characters in the token (but keep the length the same)
4 Remove the value of the token (but leave the parameter in place)
5 Convert to a GET request

If any of the above steps produce the same result as #1 then we know that the end-point is likely to be vulnerable 
(there are some instances where you might get a successful response, 
but in fact no data has been modified and therefore the token hasn’t been checked).


# A more complete CSRF testing methodology you can run through systematically.

## Baseline & Token Validation
Perform the request normally 
> Confirm success path.
> Replay the same request with the same token 
> Check for one-time use enforcement.
> Use an old/expired token (from history).
1. Remove the CSRF token parameter entirely.
2. Send token parameter with no value (X-CSRF-TOKEN=).
3. Modify one character in the token (length preserved).
4. Replace with a token of incorrect length.

## Cross-User & Session Boundaries
1. Steal another user’s valid token (if possible) 
> Test if validation is user/session-bound.
2. Use a token from one session in another session of the same user.
> Test token reuse across endpoints 
> Does a token from update_email work on change_password?

## Transport & Request Method
1. Change `POST` to `GET`.
2. Change `POST` to `PUT | DELETE`
3. Send request as [ thwart preflight requests ]
`application/x-www-form-urlencoded`, `multipart/form-data`, and `application/json`
> Some backends validate CSRF only for certain content types.
4. Send the token in a different place 
`body | query param | custom header`.

## Token Generation & Predictability
1. Look for patterns in token values (sequential, timestamp-based, reversible).
2. Check if token is tied to session ID (concatenation, base64, etc.).
Length & entropy analysis → short/static tokens may be brute-forced.

## Cookie & Header Behavior
Test with cookies stripped → if app relies only on cookies w/o CSRF token, it’s vulnerable.
Check SameSite attribute on cookies:
None without Secure → dangerous.
Lax or Strict → usually safer.
Check if custom headers (like X-CSRF-Token) are enforced only for AJAX.
Try preflight bypass: send cross-origin Content-Type: text/plain with the token → should still be rejected.

## Caching & Replay
Inspect responses for token leakage in HTML, JS, or response headers.
Check if tokens are cached by intermediary proxies/CDNs.
Replay same request after logout/re-login → should fail.

## Framework/Implementation Quirks
Case sensitivity: csrf_token vs. CSRF_TOKEN.
Encoding issues: URL-encode/HTML-encode the token.
Multiple tokens: send two token params → which one is validated?
Check for bypass in JSON APIs → some frameworks forget to validate CSRF on JSON endpoints.