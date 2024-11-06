FROM	debian:bullseye

RUN	apt-get update -y && apt-get upgrade -y && \
	apt-get install -y \
		wget \
		curl \
		bash \
		php7.4 \
		php-cgi \
		php7.4-mysql \
		php7.4-fpm \
		php7.4-pdo \
		php7.4-gd \
		php7.4-cli \
		php7.4-mbstring \
		redis \
		php-redis \
		default-mysql-client

RUN	rm -rf /var/lib/apt/lists/*

# Install wp_cli command and put it in the /usr/local/bin/wp
RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# RUN	php-fpm7.4 --version

COPY	./conf/www.conf /etc/php/7.4/fpm/pool.d/

RUN	mkdir /run/php

COPY	./tools/startup.sh /usr/local/bin/startup.sh

RUN	chmod +x /usr/local/bin/startup.sh

ENTRYPOINT	["/usr/local/bin/startup.sh"]

RUN	mkdir -p /var/www/html && \
	chmod -R 777 /var/www/html && \
	chown -R www-data:www-data /var/www/html

WORKDIR	/var/www/html/

EXPOSE	9000

# Launch PHP FPM in foreground and ignore daemonize from conf file (-F)
CMD	["php-fpm7.4", "-F"]
# CMD	["/usr/sbin/php-fpm7.4", "-F"]
