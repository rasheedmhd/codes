# Recon
1. Pull Definition files (package.json, requirements.txt, etc)
where: Electron app disass
2. Pull live Javascript files
how: js recon tools 
[Lupin & Holmes](https://www.landh.tech/blog/20250610-netflix-vulnerability-dependency-confusion/)


Raw Browser Traffic 
-> Generate HAR Files through Headless Chrome Browser 
-> Parse JS Files at the AST Level (with Rust AST)
-> Extract Candidate Package Names 
-> Feed names into Depi (Package Availability Check and Alerting module)
[ Depi -> if  Package is unclaimed, Publish, Claim Package in Remote repo and alert]
if NO! Continue 