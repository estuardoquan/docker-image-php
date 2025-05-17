FROM php:fpm-alpine AS build

USER root

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apk update && \
    apk add --no-cache \
    autoconf \ 
    freetype-dev \
    g++ \
    gifsicle \
    git \
    jpegoptim \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    make \ 
    optipng \
    pcre-dev \
    pngquant \
    unzip \
    zlib-dev && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install zip && \
    pecl install redis && \
    printf '%s\n' 'extension=redis.so' > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini && \
    printf '%s\n\n%s' '#!/bin/sh' 'php artisan "$@"' > /usr/local/bin/artisan && \
    printf '%s\n\n%s' '#!/bin/sh' 'php artisan test "$@"' > /usr/local/bin/ptest && \
    printf '%s\n\n%s' '#!/bin/sh' 'php artisan test --filter "$@"' > /usr/local/bin/ptfltrd && \
    chmod +x /usr/local/bin/artisan /usr/local/bin/ptest /usr/local/bin/ptfltrd && \
    addgroup -g 1000 laravel && \
    adduser -u 1000 -D -S -G laravel laravel && \
    mkdir -p /var/www/html && \
    chown laravel:laravel /var/www/html

FROM build AS test

COPY ./tmp/root_ca.crt /usr/local/share/ca-certificates/root_ca.crt

USER root

RUN update-ca-certificates

USER laravel

WORKDIR /var/www/html

# CMD ["php-fpm"]
