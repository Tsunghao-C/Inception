FROM	debian:bullseye

RUN	apt-get update && \
	apt-get install -y mariadb-server mariadb-client vim && \
	rm -rf /var/lib/apt/lists/*

# Set up permissions for MariaDB runtime
RUN	mkdir -p /var/run/mysqld && \
	chown -R mysql:mysql /var/run/mysqld && \
	chmod 777 /var/run/mysqld

EXPOSE	3306

COPY	./tools/startup.sh /usr/local/bin/

RUN	chmod +x /usr/local/bin/startup.sh

ENTRYPOINT	["/usr/local/bin/startup.sh"]

CMD	["mysqld", "--bind-address=0.0.0.0"]
