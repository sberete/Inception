FROM debian:bookworm

RUN apt update && apt install -y \
	php \
	php-mysql \
	curl \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html \
	&& curl -L https://www.adminer.org/latest.php -o /var/www/html/index.php

WORKDIR /var/www/html

CMD ["php", "-S", "0.0.0.0:8080"]