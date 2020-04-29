FROM php:7.0.12-apache

# Configuration for Apache
RUN rm -rf /etc/apache2/sites-enabled/000-default.conf
ADD 000-default.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite

ADD . /var/www/html/

EXPOSE 80

# Change website folder rights and upload your website
RUN chown -R www-data:www-data /var/www/html

# Change working directory
WORKDIR /var/www/html

#CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
