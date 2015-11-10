#!/bin/bash  
touch /var/run/haproxy.pid
while : ; do 
	while [ $(($(date +%s)-$(stat -c %Y /etc/hosts))) -lt 5 ]; do 
		AM_SERVERS=$(awk '/openam/{print "\tserver " $2 " " $1 ":8080 check"}' /etc/hosts)
		AM_SERVERS_S=$(awk '/openam/{print "\tserver " $2 "_s " $1 ":8443 check"}' /etc/hosts)
		IDM_SERVERS=$(awk '/openidm/{print "\tserver " $2 " " $1 ":8080 check"}' /etc/hosts)
		IDM_SERVERS_S=$(awk '/openidm/{print "\tserver " $2 "_s " $1 ":8443 check"}' /etc/hosts)
		DJ_SERVERS=$(awk '/opendj/{print "\tserver " $2 " " $1 ":1389 check"}' /etc/hosts)
		DJ_SERVERS_S=$(awk '/opendj/{print "\tserver " $2 "_s " $1 ":1636 check"}' /etc/hosts)
		perl -pe "s/PLACEHOLDER_AM_S/$AM_SERVERS_S/g; \
			s/PLACEHOLDER_IDM_S/$IDM_SERVERS_S/g; \
			s/PLACEHOLDER_DJ_S/$DJ_SERVERS_S/g; \
			s/PLACEHOLDER_AM/$AM_SERVERS/g; \
			s/PLACEHOLDER_IDM/$IDM_SERVERS/g; \
			s/PLACEHOLDER_DJ/$DJ_SERVERS/g" /usr/local/etc/haproxy/haproxy.cfg.placeholder > /usr/local/etc/haproxy/haproxy.cfg;  
		echo "Deployed new haproxy config "$(date);
		echo $AM_SERVERS_S;
		echo $IDM_SERVERS_S;
		echo $DJ_SERVERS_S;
		echo $AM_SERVERS;
		echo $IDM_SERVERS;
		echo $DJ_SERVERS;
		#DJ=$(awk '/opendj/{print $1":1389"}' /etc/hosts)
		#openssl s_client -connect $DJ
		haproxy -D -f /usr/local/etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf ; 
		sleep 3; 
	done; 
	[[ -s /var/run/haproxy.pid ]] || break
done;
