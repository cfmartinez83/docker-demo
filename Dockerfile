FROM php:7.0.12-apache

ENV DEBIAN_FRONTEND=noninteractive

# Install the PHP extensions I need for my personal project (gd, mbstring, opcache)
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev git mysql-client-5.5 wget \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring opcache pdo zip

RUN apt-get update && apt-get install -y apt-utils adduser curl nano debconf-utils bzip2 dialog locales-all zlib1g-dev libicu-dev g++ gcc locales make build-essential

# Install bz2
RUN apt-get install -y libbz2-dev
RUN docker-php-ext-install bz2

# Install mysql extension
RUN apt-get update && apt-get install -y --force-yes \
    freetds-dev \
 && rm -r /var/lib/apt/lists/* \
 && cp -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/ \
 && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
 && docker-php-ext-install \
    pdo_dblib \
    pdo_pgsql

# APC
RUN pear config-set php_ini /usr/local/etc/php/php.ini
RUN pecl config-set php_ini /usr/local/etc/php/php.ini
RUN pecl install apc

RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod mime
RUN a2enmod filter
RUN a2enmod deflate
RUN a2enmod proxy_http
RUN a2enmod headers
RUN a2enmod php7


# Clean after install
RUN apt-get autoremove -y && apt-get clean all

# Configuration for Apache
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD 000-default.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

EXPOSE 80

# Change website folder rights and upload your website
RUN chown -R www-data:www-data /var/www/html

# Change working directory
WORKDIR /var/www/html


CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
