# This is an experimental Dockerfile for our first custom image for terra.

FROM php:5.5-apache

RUN a2enmod rewrite

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush
RUN composer global require drush/drush:dev-master
ENV PATH /.composer/vendor/bin:$PATH

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql

VOLUME /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.37
ENV DRUPAL_MD5 3a70696c87b786365f2c6c3aeb895d8a

# TODO: Design ideal way to clone any git url for drupal
RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
	&& echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
	&& tar -xz --strip-components=1 -f drupal.tar.gz \
	&& rm drupal.tar.gz \
	&& chown -R www-data:www-data sites
