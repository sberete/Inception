FROM debian:bookworm

RUN apt update -y && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

CMD ["/init.sh"]