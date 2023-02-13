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

# restart Nginx to apply the changes
systemctl restart nginx

# check the Nginx configuration for syntax errors
nginx -t

echo "Nginx has been secured."
