FROM debian:bookworm

RUN apt update && apt install -y \
	php-fpm \
	php-mysql \
	curl \
	tar \
	mariadb-client \
&& rm -rf /var/lib/apt/lists/*

# Installation de WP-CLI : outil en ligne de commande pour installer/configurer WordPress automatiquement
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]