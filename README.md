


Ready for fullStack example of ForgeRocks Identity Stack Dockerized
https://github.com/ConductAS/identity-stack-dockerized.git

docker run -d -p 443:443 -p 80:80 --link openam-svc-a --link openam-svc-b --link openidm --name openam.example.com conductdocker/haproxy-iam

