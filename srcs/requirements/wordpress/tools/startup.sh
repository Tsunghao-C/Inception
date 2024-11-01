#!/bin/bash

# Check if wp-config.php exists
if [ -f ./wp-config.php ]
then
	echo "wordpress already downloaded"
else

######### MANDATORY PART ##############
	
	## for debugging
	echo "Downloading WordPress..."
	# Download wordpress and all config files
	wget http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	mv wordpress/* .
	rm -rf latest.tar.gz
	rm -rf wordpress

	## for debugging
	echo "Configuring wp-config.php with environment variables..."
	# Import env variables in the config file
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php

	## for debugging
	echo "WordPress setup completed."

#############################################

fi

# Initial setup 

wp config set WP_CACHE true --raw --allow-root

wp config set WP_DEBUG true --raw --allow-root

wp config set WP_REDIS_HOST redis --allow-root

wp config set WP_REDIS_PORT 6379 --allow-root


# Wait until mariadb is set
until wp db check --allow-root; do
	echo "Waiting for database..."
	sleep 3
done

wp core install --url="${WP_SITE_URL}" --title="${WP_SITE_TITLE}" \
	--admin_user="${WP_ADMIN_USERNAME}" --admin_password="${WP_ADMIN_PASSWORD}" \
	--admin_email="${WP_ADMIN_EMAIL}" --skip-email --allow-root

# wp theme activate twentytwentythree --allow-root
wp theme install twentytwentythree --activate --allow-root
# wp theme install pixl --activate --allow-root

# Bonus Adding redis and use RAM for frequently requested contents
wp plugin install redis-cache --activate --allow-root

wp redis enable --allow-root

if ! wp user get "${WP_USER_USERNAME}" --allow-root > /dev/null 2>&1; then
	wp user create "${WP_USER_USERNAME}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASSWORD}" --role=subscriber --allow-root
else
	echo "User '${WP_USER_USERNAME}' already exists. Skipping creation."
fi

chmod -R 777 ./wp-content

chown -R www-data:www-data ./wp-content

exec "$@"

## Okan's version
# wp core download --allow-root

# wp core config --dbhost="${WP_DB_HOST}" --dbname="${WP_DB_NAME}" \
# 	--dbuser="${WP_DB_USER}" --dbpass="${WP_DB_PASSWORD}" --allow-root

# wp config set WP_CACHE true --raw --allow-root

# wp config set WP_DEBUG true --raw --allow-root

# wp config set WP_REDIS_HOST redis --allow-root

# #wp config set WP_REDIS_PORT 6379 --allow-root

# until wp db check --allow-root; do
# 	echo "Waiting for database..."
# 	sleep 2
# done

# wp core install --url="${WP_SITE_URL}" --title="${WP_SITE_TITLE}" \
# 	--admin_user="${WP_ADMIN_USERNAME}" --admin_password="${WP_ADMIN_PASSWORD}" \
# 	--admin_email="${WP_ADMIN_EMAIL}" --skip-email --allow-root

# wp theme install pix1 --activate --allow-root

# wp plugin install redis-cache --activate --allow-root

# wp redis enable --allow-root

# wp user create "${WP_USER_USERNAME}" "${WP_USER_EMAIL}" --user_pass="${WP_USER_PASSWORD}" --role=subscriber --allow-root

# chmod -R 777 ./wp-content

# chown -R www-data:www-data ./wp-content

# exec php-fpm7.4 -F -R
