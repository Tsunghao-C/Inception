FROM	debian:bullseye

RUN	apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y nginx \
						openssl \
						curl \
						procps
# to provide ps and other process management tools

# create working directory and set access and ownership to user
RUN	mkdir -p /var/www/html && \
	chmod -R 777 /var/www/html && \
	chown -R www-data:www-data /var/www/html

# create ssl key and stor in /etc/nginx/ssl repo
RUN	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/server.key \
	-out /etc/nginx/ssl/server.crt \
	-subj "/CN=localhost"

COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./tools/startup.sh /usr/local/bin/

RUN	chmod +x /usr/local/bin/startup.sh

WORKDIR	/var/www/html

EXPOSE	443

# ENTRYPOINT	["nginx"]
ENTRYPOINT	["/usr/local/bin/startup.sh"]
# CMD		["-g", "daemon off;"]
CMD		["nginx", "-g", "daemon off;"]
