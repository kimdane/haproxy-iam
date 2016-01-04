FROM haproxy:1.5
MAINTAINER kim@conduct.no

RUN apt-get update && apt-get install -y openssl --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN if [ ! -d /etc/ssl ] ;then mkdir -p /etc/ssl ;fi
WORKDIR /etc/ssl
RUN openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 999 -nodes -subj "/CN=iam.example.com"; cat cert.pem key.pem > combined.pem
VOLUME /etc/ssl
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
CMD ["haproxy", "-db",  "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
