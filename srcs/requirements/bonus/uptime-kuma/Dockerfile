FROM debian:bookworm

RUN apt update && apt install -y git curl ca-certificates \
	&& curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
	&& apt install -y nodejs \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/louislam/uptime-kuma.git . \
	&& npm install \
	&& npm run build \
	&& npm prune --production

EXPOSE 3001

CMD ["node", "server/server.js"]