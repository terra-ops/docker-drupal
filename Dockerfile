FROM drupal:7-apache
MAINTAINER Jon Pugh <jon@thinkdrop.net>

ENV HOST_UID 1000
ENV HOST_GID 1000

# Install mysqladmin client
RUN apt-get update -qq && apt-get install -qq -y \
  mysql-client \
  php5-fpm

COPY docker-php-entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-php-entrypoint