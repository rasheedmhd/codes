Bug Bounty Playbook
Meth 1
Visit Target
Finger software and versions
Find discovered vulnerabilities or CVEs 
Find release exploits and attack the target 
Tesla F5 BIG-IP exploit
https://medium.com/@sahul1996l/how-i-discovered-an-rce-vulnerability-in-tesla-securing-a-10-000-bounty-62e725c2a6bd

Meth 1 Other V
Focus on 1-days (where? add links)
Look for exploits and CVEs (fresh)
Search elasticsearch for software and the port they are running on
Elasticsearch shows the CVEs that the software is vulnerable to
Eg: port:"9200" elastic
Try to attack target before they patch (Nagli and log4j)
Identifying the target technology stack (finger printing)
will help you find the exploits impacting that stack

You need to know the technology stack your target is running 
so you can find associated exploits

Finding Exploits 
● <TECHNOLOGY> <VERSION> vulnerabilities
● <TECHNOLOGY> <VERSION> exploits

Using Exploit db
● https://github.com/offensive-security/exploitdb (alt to the site search box, a cmnd tool)
● ./searchsploit “name of technology”

If you're looking to find what CVEs a technology stack has, 
there is no better place to search than NIST.
● https://nvd.nist.gov/vuln/search

Finding the POC
You can easily search for a CVE on Github or Exploit Db or Gitlab or Bitbucket

Exploit
Set up a vulnerable machine to test the exploit against first so you know
what to expect from a real target. Once you're ready just run the exploit on your target
and review the results to see if they are vulnerable or not.

Hacking Wordpress
https://github.com/wpscanteam/wpscan
wpscan --URL <URL>
Another thing I find all the time is directly
listing on the uploads folder. Always make sure to check:
● “/wp- content/uploads/”

Hacking Drupal
● https://github.com/droope/droopescan
● python3 droopescan scan Drupal -u <URL Here> -t 32

Hacking Joomla
● https://github.com/rezasp/joomscan
● perl joomscan.pl -u <URL Here>

Adobe AEM
● https://github.com/0ang3el/aem-hacker
● python aem_hacker.py -u <URL Here> --host <Your Public IP>

Github Pillaging
Using Githu code search (Github dorking)
https://docs.github.com/en/search-github/github-code-search/understanding-github-code-search-syntax
Refer to my notes on trufflehog

Subdomain takeover [Refer to my notes]

Firebase Realtime DB
vuln-domain.firebaseio.com/.json

Elasticsearch
List all indices
http://vuln-domain.com:9200/_cat/indices

More details
/_stats/?pretty=1
/_cluster/health
/_all/_search?q=*
ElasticSearch is unauthenticated by default
Elastic search has an http server running on port 9200 that can be used to query the
database.
Another useful technique is to list all of the field names by making a GET request to the
“/INDEX_NAME_HERE/_mapping?pretty=1
“/_all/_search?q=_exists:email&pretty=1”

MongoDB
port 27017
Use Mongo cli
mongo ip-address-here

CouchDB Port:5985,6984
CassandraDB Port:9042,9160

Bruteforcing with seclists and other wordlists
RDP     Port:3389
Telnet  Port:23
SSH     Port:22
FTP     Port:21
https://github.com/danielmiessler/SecLists/tree/master/Passwords/Default-Credentials
seclists/Passwords/Leaked-Databases/
seclist/password/Default-Credentials/default-passwords.csv

Use THC Hydra or Burp Intruder