# nginxSafe
Here are some steps to help mitigate some of the OWASP Top 10 vulnerabilities on an Nginx server:

Remove server tokens: To prevent attackers from gathering information about your server, you can remove server tokens from the Nginx header. This can be done by adding the following line to the Nginx configuration file:


server_tokens off;


Set the correct user and group for Nginx: By default, Nginx runs as the nobody user and group. To increase security, you can change the user and group to a non-privileged user, such as www-data. This can be done by adding the following lines to the Nginx configuration file:


user  www-data;
group www-data;



Disable directory listings: By default, Nginx will display a list of files in a directory if no index file is present. To prevent sensitive information from being disclosed, you can disable directory listings by adding the following line to the Nginx configuration file:


autoindex off;


Add server-side protection against XSS and CSRF attacks: You can add server-side protection against Cross-Site Scripting (XSS) and Cross-Site Request Forgery (CSRF) attacks by adding the following headers to the Nginx configuration file:


add_header X-XSS-Protection "1; mode=block";
add_header X-CSRF-Protection "1; mode=block";


Add server-side protection against MIME sniffing: You can add server-side protection against MIME sniffing by adding the following header to the Nginx configuration file:
python


add_header X-Content-Type-Options nosniff;


Limit request size: To prevent large file uploads that could exhaust server resources, you can limit the size of requests by adding the following line to the Nginx configuration file:

client_max_body_size 8M;


Add rate limiting: To prevent excessive requests from a single source, you can add rate limiting to the Nginx configuration file. For example:

limit_req_zone $binary_remote_addr zone=one:10m rate=50r/s;
limit_req_zone $http_x_forwarded_for zone=two:10m rate=50r/s;
limit_req zone=one burst=100 nodelay;
limit_req zone=two burst=100 nodelay;


Restrict access to sensitive resources: To prevent unauthorized access to sensitive resources, such as version control repositories, you can restrict access to them by adding the following location block to the Nginx configuration file:

location ~* \.(git|svn) {
    deny all;
}


Use HTTPS: To prevent eavesdropping and tampering, you should use HTTPS for all communication between the client and the server.

Keep software up-to-date: Regularly updating the software, including Nginx, can help address known vulnerabilities and prevent attacks.





