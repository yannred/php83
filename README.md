# php8.3
Generate a docker image based on Php 8.3.2 and Debian Bookworm

## Build for locally usage
> docker build -t php83 .

## Run
> docker-compose up -d

## Publish on Docker hub
```bash
docker login -u "ityannred" docker.io && \
docker build -t ityannred/debian12-apache-symfony7 . && \
docker tag debian12-apache-symfony7:latest ityrannred/debian12-apache-symfony7:latest && \
docker push ityannred/debian12-apache-symfony7:latest
```
