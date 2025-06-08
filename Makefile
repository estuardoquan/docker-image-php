AUTHOR=dqio
IMAGE=php

TAG=${AUTHOR}/${IMAGE}

all: docker-build 

docker-build: docker-build-php-fpm docker-build-php-test

docker-build-php-fpm:
	docker build -t ${TAG}:latest --target build ./

docker-build-php-test:
	docker build -t ${TAG}:test --target test ./
