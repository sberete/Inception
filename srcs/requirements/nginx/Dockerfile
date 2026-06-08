FROM debian:bookworm

RUN apt update && apt install -y \
	nginx \
	openssl \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/CN=sberete.42.fr" \
	-addext "subjectAltName=DNS:sberete.42.fr,DNS:kuma.sberete.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]