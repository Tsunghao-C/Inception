#!/bin/bash

# Initialize MariaDB data directory only if empty

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background

mysqld_safe --datadir=/var/lib/mysql &
sleep 5 # Wait for MariaDB to start

# Check if database exists

if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
	echo "Database already exists..."

else
	# Secure install for root user and grant privileges
	mysql_secure_installation << _EOF_
Y
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

	mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"

	mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;"

	# # Set root password and create inital database and user
	# mysql --user=root <<-EOSQL
	# 	ALTER USER 'root'@'${DOMAIN_NAME}' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	# 	GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
	# 	CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
	# 	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	# 	GRANT ALL ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
	# 	FLUSH PRIVILEGES;
	# EOSQL

	# if [ -f /usr/local/bin/wordpress.sql ]; then
	# 	mysql --user=root --password="${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE} < /usr/local/bin/wordpress.sql
	# fi
fi

# Stop MariaDB background process

mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Start MariaDB in the foreground

# exec mysqld --bind-address=0.0.0.0
exec "$@" 



# # Set root option so that connection wihtout password is not possible

# mysql_secure_installation << _EOF_

# Y
# $MYSQL_ROOT_PASSWORD
# $MYSQL_ROOT_PASSWORD
# Y
# n
# Y
# Y
# _EOF_

# # Add a root user on 127.0.0.1 to allow remote connection
# # Flush privileges allow your sql tables to be updated automatically when you modify it

# echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

# # Create database and user in the database for wordpress

# echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

# # Import database in the mysql command line

# mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

# fi

# /etc/init.d/mysql stop

# exec "$@"


# Okan's version
# set	-eo pipefail

# # Skip init if it's already there

# if [ ! -d "/var/lib/mysql/is_init" ]; then

# 	mysql_install_db --user=mysql --datadir=/var/lib/mysql

# 	mysqld --user=mysql --skip-networking &
# 	pid="$!"

# 	# Wait for MySQL to be ready
# 	until mysqladmin ping -h"localhost" --silent; do
# 		echo "Waiting for MariaDB to be ready..."
# 		sleep 2
# 	done

# 	mysql -e "FLUSH PRIVILEGES;"
# 	mysql -e "CREATE USER IF NOT EXISTS 'root'@'%';"
# 	mysql -e "ALTER USER 'root'@'%' IDENTIFIED BY '';"
# 	mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
# 	mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# 	mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
# 	mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;"
# 	mysql -e "FLUSH PRIVILEGES;"

# 	echo "done" > /var/lib/mysql/is_init
# 	mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown
# 	wait "$pid"
# fi

# # Start MySQL server
# exec gosu mysql "$@"