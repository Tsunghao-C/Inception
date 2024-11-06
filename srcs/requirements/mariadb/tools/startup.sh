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
	echo "Setting up MariaDB..."

	# Directly set up root user and secure the installation
	mysql -uroot <<EOSQL
	-- Set root password and disable remote root login
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	DELETE FROM mysql.user WHERE User=''; -- Remove anonymous users
	DROP DATABASE IF EXISTS test; -- Remove test database
	FLUSH PRIVILEGES;

	-- Allow root to connect from any host
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;

	-- Create initial database and user with privileges
	CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
	FLUSH PRIVILEGES;
EOSQL

	# Import initial data if available
	if [ -f /usr/local/bin/wordpress.sql ]; then
	mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" ${MYSQL_DATABASE} < /usr/local/bin/wordpress.sql
	fi

# 	# Secure install for root user and grant privileges (not suggested, interactive tty could fail)
# 	mysql_secure_installation << _EOF_
# Y
# $MYSQL_ROOT_PASSWORD
# $MYSQL_ROOT_PASSWORD
# Y
# n
# Y
# Y
# _EOF_

# 	mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# 	mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;"

fi

# Stop MariaDB background process

mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

# Start MariaDB in the foreground

exec "$@"
