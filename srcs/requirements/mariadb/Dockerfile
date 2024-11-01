FROM	debian:bullseye

RUN	apt-get update && \
	apt-get install -y mariadb-server mariadb-client vim && \
	rm -rf /var/lib/apt/lists/*

# Set up permissions for MariaDB runtime
RUN	mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

EXPOSE	3306

# RUN	sed -i '/^bind-address/c\bind-address = 0.0.0.0' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY	./tools/startup.sh /usr/local/bin/
COPY	./conf/wordpress.sql /usr/local/bin/

RUN	chmod +x /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/wordpress.sql

ENTRYPOINT	["/usr/local/bin/startup.sh"]

CMD	["mysqld", "--bind-address=0.0.0.0"]