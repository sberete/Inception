FROM debian:bookworm

RUN apt update && apt install -y vsftpd \
	&& rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

CMD ["/init.sh"]