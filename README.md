# Nginx-Vhosts
 
A simple script to create a basic VHOST for nginx.

## Installation (Ubuntu/Debian)

1. `cd /usr/local/bin`
2. `sudo curl -OL https://raw.githubusercontent.com/Metrique/nginx-vhost/master/nginx-vhost.sh`
3. `sudo curl -OL https://raw.githubusercontent.com/Metrique/nginx-vhost/master/template-nginx-vhost-php7-fpm.txt`
4. `sudo chmod +x nginx-vhost*`

## Usage (Ubuntu/Debian)
1. Edit template-nginx-vhost-php7-fpm.txt as appropriate
3. Edit nginx-vhost.sh variables as appropriate (VHOST_AVAILABLE, VHOST_ENABLED, VHOST_TEMPLATE, WWW_ROOT)
4. `sudo nginx-vhost.sh example.com` will create a vhost for example.com
