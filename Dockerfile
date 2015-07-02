FROM nginx
MAINTAINER Grant Dobbe <grant@nucivic.com>
MAINTAINER Jon Pugh <jon@thinkdrop.net>

EXPOSE 80

VOLUME /usr/share/nginx/html/

RUN  apt-get update
RUN  apt-get install -y git php5-fpm php5-gd php5-mysql nano php5-dev php5-cli php-pear
RUN  pecl install mongo

COPY drupal.conf /etc/nginx/conf.d/default.conf
COPY www.conf /etc/php5/fpm/pool.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini /etc/php5/fpm/php.ini

CMD service nginx start && service php5-fpm start && tail -f /var/log/php5-fpm.log 
