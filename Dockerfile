FROM haproxy:1.5
MAINTAINER kim@conduct.no

VOLUME ["/opt/repo"]
RUN apt-get update && apt-get install -y openssl --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

ADD run.sh /opt/run.sh
VOLUME ["/opt/repo"]

CMD ["/opt/run.sh"]
