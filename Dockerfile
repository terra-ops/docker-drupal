FROM nginx
MAINTAINER Grant Dobbe <grant@nucivic.com>
MAINTAINER Jon Pugh <jon@thinkdrop.net>

EXPOSE 80

# VOLUME /usr/share/nginx/html/
VOLUME /app

RUN  apt-get update
RUN  apt-get install -y \ 
    git \
    php5-fpm \
    php5-gd \
    php5-mysql \
    nano \
    php5-dev \
    php5-cli \
    php-pear \
    php5-curl \
    postfix
RUN  pecl install mongo

COPY drupal.conf /etc/nginx/conf.d/default.conf
COPY www.conf /etc/php5/fpm/pool.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini /etc/php5/fpm/php.ini

# Allow NGINX UID and GID to be set at runtime so we can pass in environment variables.
ENV HOST_UID 200
ENV HOST_GID 200

CMD \
# Commenting out until we can guarantee it works. Troubl e on Macs.
#  usermod -u $HOST_UID nginx && \
#  groupmod -g $HOST_GID nginx && \
  rm -rf /var/www && \
  ln -s /app/$DOCUMENT_ROOT /var/www && \
  service nginx start && \
  service php5-fpm start && \
  tail -f /var/log/php5-fpm.log
