FROM haproxy:1.5
MAINTAINER kim@conduct.no

RUN apt-get update && apt-get install -y openssl --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN if [ ! -d /etc/ssl ] ;then mkdir -p /etc/ssl ;fi
WORKDIR /etc/ssl
RUN openssl req -x509 -newkey rsa:2048 -keyout combined.pem -out combined.pem -days 999 -nodes -subj "/CN=iam.example.com"
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
VOLUME ["/etc/ssl"]
RUN sed -i 's/iam.example.com/'$(openssl x509 -noout -subject -in combined.pem | sed "s/^.*CN=//" | sed "s/\/.*$//")'/' /usr/local/etc/haproxy/haproxy.cfg
CMD ["haproxy", "-db",  "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
