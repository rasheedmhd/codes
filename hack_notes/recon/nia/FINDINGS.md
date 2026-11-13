# nia.gov.gh — Recon Findings (NSVN, separate contract; passive + gentle active reveal)
Scope: nia.gov.gh + ALL *.nia.gov.gh. EXCLUDE: niaofficial.com (www.recruitment CNAMEs there).

## Infrastructure (multi-provider)
- register/registertest/backend -> AWS ELB eu-west-1 (Laravel apps)
- www/deploy/recruitment -> Hostinger DE 212.85.30.12 (LiteSpeed, ASN 47583)
- test/appointments -> NITA gov 197.253.68.65 (Apache)
- verifyid -> 154.160.73.250 (GH) ; mobileregistration -> DigitalOcean 104.236.84.90 ; portal -> 62.72.4.128
- NS nita.gov.gh ; mail Microsoft 365

## Live app surface
| host | status | stack | role |
|------|--------|-------|------|
| register | 200 | Laravel / PHP 7.2.34 / Apache 2.4.61 (Amazon) | Ghana Card registration |
| registertest | 200 | Laravel / PHP 7.2.34 / Apache 2.4.54 | TEST registration (mirrors prod) |
| backend | 302->/login | Laravel / PHP 7.2.34 / Apache 2.4.61 | NIA Management Portal (admin) |
| test | 200 | Apache | test env |
| appointments | 200 | Apache | appointments |
| www | 301->apex | LiteSpeed | main site (Hostinger) |
| deploy, portal | 403 | LiteSpeed | exist but restricted |
| verifyid, registerid, mobileregistration | no public response | - | locked down (good) |

## Findings
### [HIGH] End-of-Life PHP 7.2.34 on the national ID system
- register, registertest, backend all run PHP 7.2.34 (EOL Nov 2019, 6+ yrs unpatched)
- Implies old Laravel (5.x/6.x era) -> CVE exposure; confirm version for report
### [MEDIUM] EOL / dated crypto+server components
- OpenSSL 1.0.2k-fips (EOL Dec 2019); Apache 2.4.54 on registertest (known CVEs)
### [INFO/GOOD] Laravel apps hardened
- No /.env, /.git, /composer.json, /storage/logs, /telescope exposure; APP_DEBUG off; docroot=/public
### Notables to pursue (gentle, pending direction)
- backend /login = admin portal (no creds tested)
- registertest = test instance of ID registration (test envs often weaker)
- deploy/portal 403 (restricted) — worth gentle path/vhost checks

## Scope guardrails
- niaofficial.com OUT OF SCOPE (exclude www.recruitment)
- Keep Host-header scoped; AWS assets are NIA tenancy
