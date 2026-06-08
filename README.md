*This project has been created as part of the 42 curriculum by sberete*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small infrastructure composed of different services using Docker and Docker Compose, all running inside a virtual machine.

The infrastructure includes:
- **NGINX** — reverse proxy with TLS 1.2/1.3 only, the single entry point (port 443)
- **WordPress** — CMS running with php-fpm (no NGINX inside)
- **MariaDB** — database for WordPress
- **Redis** — cache layer for WordPress
- **Adminer** — web-based database management UI (accessible via `/adminer/`)
- **FTP server** — vsftpd pointing to the WordPress volume
- **Static site** — a custom HTML/CSS showcase site (accessible via `/fatherfinder/`)
- **Uptime Kuma** — service monitoring dashboard (accessible via `kuma.sberete.42.fr`)

All containers are built from `debian:bookworm` and orchestrated with Docker Compose. Data is persisted via named volumes bound to `/home/sberete/data/`.

## Instructions

### Requirements

- Docker and Docker Compose installed
- A virtual machine running Linux
- The following entries added to `/etc/hosts`:
  ```
  127.0.0.1  sberete.42.fr
  127.0.0.1  kuma.sberete.42.fr
  ```

### Launch the project

```bash
make
```

This will create the required data directories and start all services.

### Stop the project

```bash
make down
```

### Full reset (removes volumes)

```bash
make fclean
```

### Access the services

| Service       | URL                              |
|---------------|----------------------------------|
| WordPress     | https://sberete.42.fr            |
| Adminer       | https://sberete.42.fr/adminer/   |
| Static site   | https://sberete.42.fr/fatherfinder/ |
| Uptime Kuma   | https://kuma.sberete.42.fr       |

> A self-signed SSL certificate is used. Your browser will show a security warning — this is expected.

## Resources

### Documentation consulted

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [Redis documentation](https://redis.io/docs/)
- [Uptime Kuma](https://github.com/louislam/uptime-kuma)

### Use of AI

AI (Claude by Anthropic) was used during this project for research and documentation purposes: understanding Docker concepts, looking up configuration options for services (NGINX, php-fpm, vsftpd), and clarifying documentation on tools like WP-CLI and Redis cache integration.
