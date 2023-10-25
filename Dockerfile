# Use a imagem oficial do PHP como base
FROM php:7.4-fpm

# Atualize a lista de pacotes e instale as dependências necessárias
RUN apt-get update && apt-get install -y  --no-install-recommends\
    apt-utils \ 
    libzip-dev \
    unzip \
    supervisor

# dependências recomendadas de desenvolvido para ambiente linux
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    libxml2-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql pdo_pgsql pgsql session xml
# Instale o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Defina o diretório de trabalho como a pasta do seu projeto Laravel
WORKDIR /var/www/html

# Copie o arquivo composer.json e composer.lock para o contêiner
COPY composer.json composer.lock ./

RUN apt-get update -y && apt-get install -y openssl zip unzip git
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get install zlib1g-dev -y && apt-get install zlib1g && apt-get install libpng-dev -y && apt-get install -y libzip-dev && apt-get install redis-server -y
RUN docker-php-ext-install pdo pdo_mysql gd zip

RUN composer install

# Limpe o cache do Laravel 
RUN php artisan optimize:clear

# Execute as migrações do banco de dados forçando
RUN php artisan migrate --force

# Execute o comando para criar o link simbólico para o armazenamento
RUN php artisan storage:link

# Exponha a porta 9000 para a comunicação com o servidor web
EXPOSE 9000

# Inicie o servidor PHP-FPM
CMD ["php-fpm"]
