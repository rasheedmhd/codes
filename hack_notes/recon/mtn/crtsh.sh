#!/bin/bash
> subs_crtsh.txt
while read -r d; do
  [ -z "$d" ] && continue
  curl -s --max-time 25 "https://crt.sh/?q=%25.${d}&output=json" \
    | jq -r '.[].common_name, .[].name_value' 2>/dev/null \
    | sed 's/\*\.//g' | tr 'A-Z' 'a-z' | grep -F ".$d" >> subs_crtsh.txt
  sleep 1
done < roots_mtn_apex.txt
sort -u subs_crtsh.txt -o subs_crtsh.txt
echo "crtsh done: $(wc -l < subs_crtsh.txt) names"
