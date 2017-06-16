#!/bin/sh

if [ ! -d /etc/ssl ]; then mkdir -p /etc/ssl; fi
cd /etc/ssl
if [ -f /opt/repo/ssl/combined.pem ]; then
	cp /opt/repo/ssl/combined.pem /etc/ssl/combined.pem
	sed -i 's/iam.example.com/'$(openssl x509 -noout -subject -in /etc/ssl/combined.pem | sed "s/^.*CN=\*\./iam./" | sed "s/^.*CN=//" | sed "s/\/.*$//")'/' /usr/local/etc/haproxy/haproxy.cfg
else
	openssl req -x509 -newkey rsa:2048 -keyout combined.pem -out combined.pem -days 999 -nodes -subj "/CN=iam.example.com"	
fi

haproxy -db -f /usr/local/etc/haproxy/haproxy.cfg
