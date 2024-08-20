# php8.3
Generate a docker image based on Php 8.3.2 and Debian Bookworm

## Build for locally usage
> docker build -t php83 .

## Run
> docker-compose up -d

## Publish on Docker hub
```bash
docker login -u "ityannred" docker.io && \
docker build -t ityannred/php83 . && \
docker tag php83:latest ityrannred/php83:latest && \
docker push ityannred/php83:latest
```
