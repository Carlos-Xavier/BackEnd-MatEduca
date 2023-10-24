# Use a imagem oficial do PHP como base
FROM php:7.4-fpm

# Atualize a lista de pacotes e instale as dependências necessárias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip

# Instale o Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Defina o diretório de trabalho como a pasta do seu projeto Laravel
WORKDIR /var/www/html

# Copie o arquivo composer.json e composer.lock para o contêiner
COPY composer.json composer.lock ./

# Instale as dependências do Composer
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

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
