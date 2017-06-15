FROM haproxy:1.5
MAINTAINER kim@conduct.no

RUN apt-get update && apt-get install -y openssl --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN if [ ! -d /etc/ssl ] ;then mkdir -p /etc/ssl ;fi
RUN if [ ! -f /etc/ssl/combined.pem ] ;then cd /etc/ssl; openssl req -x509 -newkey rsa:2048 -keyout combined.pem -out combined.pem -days 999 -nodes -subj "/CN=iam.example.com"; fi
WORKDIR /etc/ssl
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
VOLUME ["/etc/ssl"]
RUN sed -i 's/iam.example.com/'$(openssl x509 -noout -subject -in /etc/ssl/combined.pem | sed "s/^.*CN=\*\./iam./" | sed "s/^.*CN=//" | sed "s/\/.*$//")'/' /usr/local/etc/haproxy/haproxy.cfg
CMD ["haproxy", "-db",  "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
