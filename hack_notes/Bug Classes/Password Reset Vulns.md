# 1. OTP rate limit bypass 
Ensure that the application imposes a rate limit on OTP attempts.
Check if the system locks the account or introduces a delay after a certain number of failed OTP entries.

# 2. Predictable Tokens
Look for patterns in the tokens (e.g., sequential numbers, short-length tokens, or tokens that appear similar for multiple users).
Ensure that tokens are sufficiently random and long enough to resist guessing attempts.

# 3. JWT - signing and encryption issues (JWT misconfiguration)
Check if the JWT is signed and validated properly.
Verify that the token’s expiration time is set correctly and cannot be tampered with.

# 4. IDOR 
[0-Click Account Takeover via Password Reset](https://hackerone.com/reports/2831902)
Test if modifying the user ID or token in the password reset URL allows access to another user’s account.
Ensure that the system validates ownership of the account before allowing a password reset.

# 4. Host Header injection 
Ensure that the Host header is properly validated and sanitized to prevent injection attacks.
Test if malicious host headers can cause a redirection to an external malicious website during password reset flows.

# 6 Leaked Tokens or OTPs in HTTP Responses
[password reset token leaking allowed for ATO of an Uber account](https://hackerone.com/reports/173551)
Check if tokens or OTPs are exposed in URLs or HTTP responses.
Ensure that tokens and OTPs are only available in request bodies or secure storage, never in URLs or responses.

# 7. Proper OTP or Token Validation 
[MTN Client - Server DeSync](https://hackerone.com/reports/2762462)
Verify that the system correctly validates the expiration of OTPs or reset tokens.
Check if the system handles duplicate or reused tokens properly.

# 8. HTTP Parameter Pollution 
[UPArchive](https://hackerone.com/reports/1175081)
```
{"email":["victim@gmail.com","attacker@gmail.com"]}
```
[$35k GitLab ATO](https://hackerone.com/reports/2293343)
Check if the password reset flow is vulnerable to HPP attacks by injecting extra parameters in the HTTP request.
Test how the system handles multiple occurrences of the same parameter in a single request.


# 9. Password Reset Poisoning
[Password reset link injection allows redirect to malicious URL](https://hackerone.com/reports/281575)

# Bypassing Host Header Validation
> Host: example.com?.mavenlink.com
[Generating HTTP reset link with Http instead of https](https://hackerone.com/reports/1888915)

# Storing reset tokens in cookies
[Reset password cookie leads to account takeover](https://hackerone.com/reports/1004536)
