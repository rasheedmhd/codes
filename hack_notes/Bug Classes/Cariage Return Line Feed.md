# Carriage Return (\n) Line Feed (\r) Injection 
Originates where browsers fail to sanitize special characters and 
send them to the server which interprets them at the OS level

# Causes 
Forgetfulness
Improper Sanitation of special characters
Interpreting backward compatible HTTP/0.9 and HTTP/1.1

    %OD %0A 
    \n  \r

# CRLFs can lead to 
## HTTP request smuggling
- Where on is able to add another request to the initial legit request 
!= Parameter pollution bc HPP duplicates req parameters != full requests

Exploiting it can lead to 
1. Cache poisoning, - modify app caches to arbitrary pages and 
return illegitimate pages when the right pages are requested 
2. Firewall by pass/evasion, 
Request hijacking - stealing `httponly` cookies and 
HTTP authentication information with no interaction between the attacker and client. 

## HTTP response splitting
Allows an attacker to split a single HTTP response by injecting new headers that browsers interpret.