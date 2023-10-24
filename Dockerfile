FROM composer:2.4 as build 
COPY . /app/ 

FROM php:8.2-apache-buster as dev 
ENV APP_ENV=dev 
ENV APP_DEBUG=true 
ENV COMPOSER_ALLOW_SUPERUSER=1 

RUN apt-get update && apt-get install -y zip 
RUN docker-php-ext-install pdo pdo_mysql 

COPY . /var/www/html/ 
COPY --from=build /usr/bin/composer /usr/bin/composer 
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --prefer-dist --no-interaction 
CMD ["php","artisan","serve","--host=0.0.0.0"]
