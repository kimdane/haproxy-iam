FROM haproxy:latest

MAINTAINER Kim Daniel Engebretsen


# Expose ports for global use
EXPOSE 636 389 443 80

COPY haproxy.cfg.placeholder /usr/local/etc/haproxy/haproxy.cfg.placeholder
COPY combined.pem /usr/local/etc/haproxy/combined.pem
COPY custom_run.sh /usr/local/etc/haproxy/custom_run.sh

# Set script to execute on run
CMD ["/usr/local/etc/haproxy/custom_run.sh"]

