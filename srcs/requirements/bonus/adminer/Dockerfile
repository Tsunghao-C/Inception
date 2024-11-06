FROM debian:bullseye

RUN apt-get update -y && \
    apt install -y curl php php-fpm php-mysql && \
    rm -rf /var/lib/apt/lists/*

RUN php-fpm7.4 --version

RUN sed -i 's|^listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:7000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html/adminer && \
    chmod -R 777 /var/www/html/adminer && \
    chown -R www-data:www-data /var/www/html/adminer

RUN mkdir -p /run/php

COPY ./tools/startup.sh /usr/local/bin/startup.sh

RUN chmod +x /usr/local/bin/startup.sh

WORKDIR /var/www/html/adminer

EXPOSE  7000

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]

CMD [ "/usr/sbin/php-fpm7.4", "-F" ]