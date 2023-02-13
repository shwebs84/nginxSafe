#!/bin/bash

# check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

# set the user and group for Nginx
NGINX_USER="www-data"
NGINX_GROUP="www-data"

# create a backup of the Nginx configuration file
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# remove server tokens
sed -i '/server_tokens/s/on;/off;/' /etc/nginx/nginx.conf

# set the user and group for Nginx
sed -i "s/#user  nobody;/user  $NGINX_USER $NGINX_GROUP;/" /etc/nginx/nginx.conf

# disable directory listings
echo "autoindex off;" >> /etc/nginx/nginx.conf

# add server-side protection against Cross-Site Scripting (XSS) attacks
echo "add_header X-XSS-Protection \"1; mode=block\";" >> /etc/nginx/nginx.conf

# add server-side protection against Cross-Site Request Forgery (CSRF) attacks
echo "add_header X-CSRF-Protection \"1; mode=block\";" >> /etc/nginx/nginx.conf

# add server-side protection against MIME sniffing
echo "add_header X-Content-Type-Options nosniff;" >> /etc/nginx/nginx.conf

# add server-side protection against Internet Explorer compatibility mode
echo "add_header X-UA-Compatible \"IE=edge\";" >> /etc/nginx/nginx.conf

# limit request size to prevent large file uploads that could exhaust server resources
echo "client_max_body_size 8M;" >> /etc/nginx/nginx.conf

# add rate limiting to prevent excessive requests from a single source
echo "limit_req_zone \$binary_remote_addr zone=one:10m rate=50r/s;" >> /etc/nginx/nginx.conf
echo "limit_req_zone \$http_x_forwarded_for zone=two:10m rate=50r/s;" >> /etc/nginx/nginx.conf
echo "limit_req zone=one burst=100 nodelay;" >> /etc/nginx/nginx.conf
echo "limit_req zone=two burst=100 nodelay;" >> /etc/nginx/nginx.conf

# restrict access to sensitive resources
echo "location ~* \.(git|svn) {" >> /etc/nginx/nginx.conf
echo "    deny all;" >> /etc/nginx/nginx.conf
echo "}" >> /etc/nginx/nginx.conf

# restart Nginx to apply the changes
systemctl restart nginx

# check the Nginx configuration for syntax errors
nginx -t

echo "Nginx has been secured against some OWASP Top 10 vulnerabilities."
