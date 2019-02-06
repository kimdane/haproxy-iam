#!/bin/sh

if [ -f /etc/ssl/combined.pem ]; then
	FQDN=$(openssl x509 -noout -subject -in /etc/ssl/combined.pem | sed "s/^.*CN=\*\./iam./" | sed "s/^.*CN=//" | sed "s/\/.*$//")
	sed -i "s/iam.example.com/$FQDN/g" /usr/local/etc/haproxy/haproxy.cfg
else
	mkdir -p /etc/ssl
	cd /etc/ssl
	openssl req -x509 -newkey rsa:2048 -keyout combined.pem -out combined.pem -days 999 -nodes -subj "/CN=iam.example.com"	
fi

haproxy -db -f /usr/local/etc/haproxy/haproxy.cfg
