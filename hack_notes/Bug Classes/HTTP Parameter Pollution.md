# HTTP Parameter Pollution
This happens when you send extra HTTP URL parameters to the servers to observe how it handles them. 
You can send custom parameters or duplicate parameter value

# HPP exists in two forms server and client side
### Server Side 
You send the server unexpected parameters to exploit how it handles them
In the case of sending extra parameters, several server softwares 
handle that situation in different ways. 

In Recon and fingerprinting you can make an educated guess on which server is used in the backend
so you can make an educated guess as to what will happen with the  extra parameters you send.

Apache + PHP = last occurence
Tomcat = first occurence
ASP + IIS = all occurences

[Stefan Di Paolo + Luca Carettoni OG Research Slide](https://www.slideshare.net/slideshow/http-parameter-pollution-a-new-category-of-web-attacks/1457503)

https://www.slideshare.net/slideshow/http-parameter-pollution-vulnerabilities-in-web-applications-black-hat-eu-2011/7306673