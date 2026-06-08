#!/bin/bash

set -e

mkdir -p /run/php
mkdir -p /var/www/html

sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

until mysqladmin ping -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
	echo "Waiting for MariaDB..."
	sleep 2
done

cd /var/www/html

if [ ! -f wp-config.php ]; then
	wp core download --allow-root

	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="mariadb" \
		--allow-root
fi

if ! wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
	wp core install \
		--url="https://${DOMAIN_NAME}" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root

	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--allow-root
fi

wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --raw --allow-root

if ! wp plugin is-installed redis-cache --allow-root; then
	wp plugin install redis-cache --activate --allow-root
else
	wp plugin activate redis-cache --allow-root
fi

wp redis enable --allow-root || true

exec php-fpm8.2 -F