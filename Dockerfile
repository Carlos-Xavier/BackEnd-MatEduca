
RUN composer update --ignore-platform-reqs
RUN composer install --ignore-platform-reqs --prefer-dist --no-interaction 
