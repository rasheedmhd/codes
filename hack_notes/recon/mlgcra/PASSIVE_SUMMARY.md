# mlgcra.gov.gh — Passive Recon Summary (NSVN engagement)

## Target
- Ministry of Local Government, Chieftaincy & Religious Affairs (Ghana)
- In-scope host: mlgcra.gov.gh (+ www, cp)

## Hosts / DNS
- www.mlgcra.gov.gh -> 197.253.124.29
- cp.mlgcra.gov.gh  -> 197.253.124.29   [cPanel control panel]
- NS: ns1-5.nita.gov.gh (NITA-managed)
- MX/SPF: Microsoft 365 (Outlook protection)

## Network
- IP 197.253.124.29 | ASN 37313 (GH, AFRINIC) | 197.253.124.0/24
- SHARED HOSTING — co-located gov domains (OUT OF SCOPE): mlgrd.gov.gh, mofa.gov.gh (aquaculture)

## Footprint
- CT logs (crt.sh, certspotter): empty
- Wayback: empty
- Passive subdomains: only www + cp

## Active-phase watch items (pending authorization)
- cPanel exposure (cp.): ports 2082/2083/2086/2087/2095/2096, WHM
- Scope by Host header mlgcra.gov.gh ONLY — never scan raw IP (hits mlgrd/mofa)
- Likely PHP/WordPress on cPanel shared host
