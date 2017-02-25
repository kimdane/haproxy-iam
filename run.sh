#!/bin/sh

if [ ! -d /etc/ssl ] ;then 
	mkdir -p /etc/ssl 
fi
cd /etc/ssl
if [ -f /opt/repo/tls/combined.pem ]; then
	cp /opt/repo/tls/combined.pem /etc/ssl/combined.pem
else
	openssl req -x509 -newkey rsa:2048 -keyout combined.pem -out combined.pem -days 999 -nodes -subj "/CN=iam.example.com"	
fi
sed -i 's/iam.example.com/'$(openssl x509 -noout -subject -in combined.pem | sed "s/^.*CN=//" | sed "s/\/.*$//")'/' /usr/local/etc/haproxy/haproxy.cfg

haproxy -db -f /usr/local/etc/haproxy/haproxy.cfg
