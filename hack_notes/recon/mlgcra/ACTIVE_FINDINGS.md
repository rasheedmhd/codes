# mlgcra.gov.gh — Active Recon Findings (NSVN, reveal-only, gentle)
Scope: mlgcra.gov.gh + *.mlgcra.gov.gh (Host-header scoped, NOT raw IP — shared host w/ mlgrd/mofa)

## Revealed attack surface

### 1. [CRITICAL — reveal only] Hestia Control Panel v1.9.4 exposed on cp.mlgcra.gov.gh:8083
- Login page open (HTTP 200), version 1.9.4 confirmed in page title/assets
- **CVE-2026-43633**: unauthenticated deserialization RCE (ROOT) in web-terminal component, affects 1.9.0–1.9.4 (CWE-502)
- Public RCE also referenced for 1.9.3
- NOT exploited. Exploitability depends on web-terminal feature being enabled.
- Fix: patch past PR #5244 / disable web terminal
- Panel also answers on :443 (301 -> http)

### 2. [MEDIUM] Expired TLS certificate on main site
- mlgcra.gov.gh / www: Let's Encrypt cert expired 2026-05-28 (checked 2026-07-07)

### 3. [INFO/LOW] Laravel staff portal
- Custom Laravel + Vite app ("Staff Login - MLGCRA" at /login, email+password)
- Hardened: /.env, /.git, /storage/logs, /telescope, /horizon all 404; APP_DEBUG appears OFF (no stack-trace leak)
- Authentication surface only; no creds tested

### 4. [LOW] Missing security headers on main site
- No CSP, X-Frame-Options, X-Content-Type-Options (HSTS present)

## Environment
- nginx | Laravel (encrypted XSRF-TOKEN + mlgcra_session cookies) | Alpine.js frontend
- Host 197.253.124.29 | ASN 37313 (Ghana Gov / Min. of Communications)
- Shared hosting: mlgrd.gov.gh, mofa.gov.gh co-located (OUT OF SCOPE)

## Not yet done (pending direction)
- Gentle nuclei detection pass (CVEs/misconfigs/exposures)
- Gentle content discovery (reveal app paths/admin)
- DNS brute-force for more *.mlgcra.gov.gh

## AUTH FLOW REVIEW (register / login / password reset) — reveal-only

### Method note
Server-side auth controllers are NOT exposed (/.git, /.env, index.php.bak[=HTML only] all checked).
Review based on: composer.json (exposed), route probing (GET), login page HTML, and a leaked debug trace.

### [HIGH] APP_DEBUG=true in production -> stack trace info disclosure
- GET /forgot-password -> HTTP 500 full Laravel debug trace (316KB)
- Leaks: absolute paths, app structure, OS/panel user "mlgrcagov"
  - webroot: /home/mlgrcagov/web/mlgcra.gov.gh/public_html/
  - auth: App\Http\Controllers\Auth\PasswordResetLinkController (Breeze-style)
- spatie/laravel-ignition ^2.0 present -> assess CVE-2021-3129 (Ignition RCE) applicability (NOT exploited)
- CWE-489 / CWE-200

### [MEDIUM] Password reset flow is BROKEN
- /forgot-password route exists but references missing view auth.forgot-password -> 500
- Reset is non-functional (availability) and is the trigger for the debug leak above

### Registration
- No /register route, no register link on /login -> self-registration DISABLED (good posture)
- No RegisterController evidenced

### Login
- /login POST (email+password, CSRF _token), Breeze-scaffold, RedirectIfAuthenticated middleware
- Logic checks (enumeration, throttling/lockout, token handling) require dynamic testing -> side effects (emails/lockout), NOT done pending explicit auth

### Correlation
- Leaked OS user "mlgrcagov" is a likely valid username for the exposed Hestia panel (:8083) -> pairs with CVE-2026-43633. Not tested.

## CURATED CONTENT DISCOVERY (Laravel/PHP-tuned wordlist, gentle ffuf)

### [HIGH] Exposed phpMyAdmin login — /phpmyadmin/
- Live phpMyAdmin 5.2.2 (confirmed /phpmyadmin/README, /phpmyadmin/ChangeLog readable)
- Internet-facing DB admin panel on a gov host -> credential-attack surface to the database
- 5.2.2 is current (no obvious version CVE); risk is the exposure + readable README/ChangeLog version disclosure
- NOT tested (no login attempts)

### [LOW-MED] Dependency inventory disclosure
- Readable: /composer.json, /package.json, /package-lock.json, /vendor/composer/installed.json (227KB), /phpunit.xml, /vite.config.js
- Full exact-version list -> precise CVE mapping of all packages

### CORRECTION: app source/config/logs are NOT web-readable
- Dir requests (/app /config /storage /routes /vendor ...) 301 (dirs exist) BUT
- files inside (laravel.log, composer.lock, config/database.php, routes/web.php, .env) -> Laravel 404
- nginx try_files -> /index.php fallback protects them. Earlier "app root exposed" overstated.

### Not findings
- /documents = legitimate public "Documents & Resources" page (not a listing)
- /sanctum/csrf-cookie 204 (Sanctum SPA auth active); /api/user 302->login (auth-gated)

## CONSOLIDATED SEVERITY
- CRITICAL: Hestia CP 1.9.4 exposed :8083 -> CVE-2026-43633 unauth root RCE (not tested)
- HIGH: phpMyAdmin login exposed /phpmyadmin/
- HIGH: APP_DEBUG=true -> stack-trace info disclosure (paths, OS user mlgrcagov, app structure)
- MEDIUM: password reset broken (missing auth.forgot-password view)
- MEDIUM: expired TLS cert (main site)
- LOW-MED: dependency inventory disclosure
- LOW: missing security headers (CSP/XFO/XCTO); phpMyAdmin README/ChangeLog readable
- GOOD: registration disabled; app source protected; debug-RCE not confirmed
