#!/bin/bash
h="$1"
out=$(dig +short +time=2 +tries=1 @1.1.1.1 "$h" A | grep -E '^[0-9]' | head -2 | tr '\n' ',')
cn=$(dig +short +time=2 +tries=1 @1.1.1.1 "$h" CNAME | head -1)
[ -n "$out" ] && printf '%-38s %s %s\n' "$h" "$out" "${cn:+(cname:$cn)}"
