## Summary of the Issue
The web application is vulnerable to a cache poisoning issue on the following endpoint:
 
```
<URL>
```
 
The responses to GET requests are being served from a public cache, however due to the lack of the request body being present in the cache keys, we can achieve <insert vulnerability> via the <parameter_name> parameter of our requests.
 
## Steps to reproduce
 
1. Open Burp Suite and ensure it's sniffing all HTTP(S) requests in the background.
2. Navigate to <endpoint>. Find the request to this endpoint in Burp's proxy history and send it to the repeater.
3. Add the following cachebuster as a GET parameter: 'dontpoison=true'. This will ensure to isolate the resulting exploit to users who make requests to this endpoint with the 'dontpoison' parameter & value pair present.
4. Insert the following POST parameter and value to the request body:
 
<param>=<value>
 
The entire request should now look like:
 
<Full HTTP Request>
 
5. Submit the request 8-10 times. Remove the POST parameter and value pair that was added in the previous step. 
6. Change your IP address, and submit the request again. As you can see, the exploit has persisted, showing caching poisoning.
  
## Impact statement
An attacker can poison the response served from the public cache to all users who navigate to the affected endpoint, resulting in <vulnerability name>
 
## Remediation
 
Ensure that the application does not process the HTTP body of a GET request.