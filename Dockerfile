FROM php:5.6-apache

RUN docker-php-ext-install mysqli pdo_mysql
RUN a2enmod rewrite

RUN apt-get update \
&& apt-get install -y \
libz-dev libmemcached-dev libmemcached11 libmemcachedutil2 build-essential memcached libzip-dev zip \
&& pecl install memcached-2.2.0 \
&& echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini \
&& apt-get remove -y build-essential libmemcached-dev libz-dev \
&& apt-get autoremove -y \
&& apt-get clean \
&& rm -rf /tmp/pear

RUN docker-php-ext-configure zip --with-libzip \
&& docker-php-ext-install zip

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 777 /var/www/html \
    && ls -al /var/www/html

RUN docker-php-ext-enable opcache

# ADDING SRC
ADD . /var/www/html/

# EXPOSE PORT
EXPOSE 80

# Change working directory
WORKDIR /var/www/html

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
