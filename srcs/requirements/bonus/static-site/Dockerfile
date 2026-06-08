FROM debian:bookworm

RUN apt update && apt install -y nginx \
	&& rm -rf /var/lib/apt/lists/*

COPY website /var/www/html

CMD ["nginx", "-g", "daemon off;"]