#!/bin/bash
mkdir optnmap_diff
d=$(date +%Y-%m-%d)
y=$(date -d yesterday +%Y-%m-%d)
usrbin/nmap -T4 -oX optnmap_diff/scan_$d.xml 10.100.100.0/24 >
devnull 2>&1
if [ -e optnmap_diff/scan_$y.xml ]; then
usrbin/ndiff optnmap_diff/scan_$y.xml
optnmap_diff/scan_$d.xml > optnmap_diff/diff.txt
fi