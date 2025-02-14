AUTHOR=dqio
IMAGE=php

TAG=${AUTHOR}/${IMAGE}

all: docker-build 

docker-build: docker-build-php

docker-build-php:
	docker build -t ${TAG}:latest ./
