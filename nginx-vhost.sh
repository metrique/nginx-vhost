#!/bin/bash

VERSION=v0.2

BASE_DIR=$(dirname $0)
DOMAIN=$1
PUBLIC_DIR=public

# Full path to vhost available - you should create this if it doesn't exist.
VHOST_AVAILABLE=/etc/nginx/sites-available

# Should script chown newly created vhosts?
VHOST_CHOWN=true

# Which User/Group do we chown the vhost with?
VHOST_CHOWN_USER=ubuntu
VHOST_CHOWN_GROUP=ubuntu

# Full path to vhost enabled - this should exist already as part of your nginx installation
VHOST_ENABLED=/etc/nginx/sites-enabled

# Place template in same directory as this script.
VHOST_TEMPLATE=$BASE_DIR/template-nginx-vhost-php5-fpm.txt

# Vhost Directory Root.
WWW_ROOT=/home/ubuntu/web

# Log root
LOG_ROOT=/var/log/nginx

# Nginx root
NGINX_ROOT=/etc/nginx

MSG_ERR=ERR:
MSG_INFO=INFO:
MSG_OK=OK:
MSG_DONE=DONE...

echo ""
echo "-> nginx-vhost $VERSION"

# Check for domain name parameter
if [[ -z "$DOMAIN" ]]; then
	echo "-> $MSG_ERR Please pass domain name, eg ./nginx-vhost.sh example.com"
	echo "-> $MSG_DONE"
	echo ""
	exit 1
fi

# Check for sudo
if [[ "$(whoami)" != "root" ]]; then
	echo "-> $MSG_ERR Sorry, you are not root - try sudo?"
	echo "-> $MSG_DONE"
	echo ""
	exit 1
fi

# Check for VHOST_DIR
if [[ ! -d "$VHOST_AVAILABLE" ]]; then
	read -p "-> MSG_ERR $VHOST_AVAILABLE doesn't exist. Create it? (y/n) " -n 1 -r
	echo ""

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		mkdir -p $VHOST_AVAILABLE
	else
		echo "-> $MSG_DONE"
		echo ""
		exit 1
	fi
fi

# Check for VHOST_DIR
if [[ ! -d "$VHOST_ENABLED" ]]; then
	read -p "-> MSG_ERR $VHOST_ENABLED doesn't exist. Create it? (y/n) " -n 1 -r
	echo ""

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		mkdir -p $VHOST_ENABLED
	else
		echo "-> $MSG_DONE"
		echo ""
		exit 1
	fi
fi

# Check for WWW_ROOT
if [[ ! -d "$WWW_ROOT" ]]; then
	echo "-> $MSG_ERR $WWW_ROOT doesn't exist"
	echo "-> $MSG_DONE"
	echo ""
	exit 1
fi

# Check for WWW_ROOT/DOMAIN
if [[ -d "$WWW_ROOT/$DOMAIN" ]]; then
	echo "-> $MSG_ERR $WWW_ROOT/$DOMAIN already exists, please (re)move it first"
	echo "-> $MSG_DONE"
	echo ""
	exit 1
fi

# Check for VHOST_DIR/DOMAIN
if [[ -f "$VHOST_AVAILABLE/$DOMAIN" ]]; then
	echo "-> $MSG_ERR $VHOST_AVAILABLE/$DOMAIN already exists, please (re)move it first"
	echo "-> $MSG_DONE"
	echo ""
	exit 1
fi

# Check for VHOST_TEMPLATE
if [[ ! -f "$VHOST_TEMPLATE" ]]; then
	echo "-> $MSG_ERR $VHOST_TEMPLATE doesn't exist"
	echo "-> $MSG_DONE"
	echo ""
	exit 1
fi

# Create Vhost directories
mkdir -p $WWW_ROOT/$DOMAIN
mkdir -p $WWW_ROOT/$DOMAIN/site/$PUBLIC_DIR
mkdir $WWW_ROOT/$DOMAIN/ssl
mkdir $WWW_ROOT/$DOMAIN/log

echo "Welcome to $DOMAIN" > $WWW_ROOT/$DOMAIN/site/$PUBLIC_DIR/index.html
if [ "$VHOST_CHOWN" = true ]; then
	chown -R $VHOST_CHOWN_USER:$VHOST_CHOWN_GROUP $WWW_ROOT/$DOMAIN
fi

# Create vhost record from template
sed -e "s;%WWW_ROOT%;$WWW_ROOT;" -e "s;%DOMAIN%;$DOMAIN;" -e "s;%PUBLIC_DIR%;$PUBLIC_DIR;" -e "s;%LOG_ROOT%;$LOG_ROOT;" $VHOST_TEMPLATE > $VHOST_AVAILABLE/$DOMAIN.conf
# cp -prf $VHOST_AVAILABLE/$DOMAIN.conf $VHOST_ENABLED/$DOMAIN.conf
ln -s $VHOST_AVAILABLE/$DOMAIN.conf $VHOST_ENABLED/$DOMAIN.conf

echo "-> $MSG_INFO nginx-vhost for $1 successfully created!"
echo "-> $MSG_DONE"
exit 1
