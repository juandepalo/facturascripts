FROM php:7-apache

RUN apt-get update \
  && apt-get install -y --no-install-recommends git  libpng-dev zlib1g-dev libzip-dev zip unzip

RUN docker-php-ext-install pdo_mysql zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install gd
RUN docker-php-ext-install mysqli


RUN pecl install xdebug \
  && docker-php-ext-enable xdebug  

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
  mv composer.phar /usr/local/bin/composer

RUN rm -rf /var/lib/apt/lists/*
COPY . /var/www/html
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html
RUN composer install
RUN chown -R www-data:www-data /var/www/html \
  && a2enmod rewrite

