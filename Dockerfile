FROM php:7.4-fpm

# Atualize a lista de pacotes e instale as dependências necessárias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip
RUN composer -d memory_limit=-1 install && php artisan optimize:clear && php artisan migrate --force
