# Developer Documentation — Inception

## Prerequisites

- Docker Engine (>= 20.x)
- Docker Compose plugin (>= 2.x)
- A Linux virtual machine (as required by the 42 subject)
- `make` installed
- `/etc/hosts` configured with:
  ```
  127.0.0.1  sberete.42.fr
  127.0.0.1  kuma.sberete.42.fr
  ```

---

## Repository structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    └── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/nginx.conf
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/init.sh
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/init.sh
        └── bonus/
            ├── redis/Dockerfile
            ├── adminer/Dockerfile
            ├── ftp/
            │   ├── Dockerfile
            │   └── tools/init.sh
            ├── static-site/
            │   ├── Dockerfile
            │   └── website/
            └── uptime-kuma/Dockerfile
```

---

## Environment variables

All configuration is stored in `srcs/.env`. This file must **not** be committed to git.

| Variable            | Description                        |
|---------------------|------------------------------------|
| `DOMAIN_NAME`       | Domain used for the site           |
| `WP_TITLE`          | WordPress site title               |
| `MYSQL_DATABASE`    | MariaDB database name              |
| `MYSQL_USER`        | MariaDB WordPress user             |
| `MYSQL_PASSWORD`    | MariaDB WordPress user password    |
| `MYSQL_ROOT_PASSWORD` | MariaDB root password            |
| `WP_ADMIN_USER`     | WordPress admin username           |
| `WP_ADMIN_PASSWORD` | WordPress admin password           |
| `WP_ADMIN_EMAIL`    | WordPress admin email              |
| `WP_USER`           | WordPress author username          |
| `WP_USER_PASSWORD`  | WordPress author password          |
| `WP_USER_EMAIL`     | WordPress author email             |

---

## Makefile targets

| Target    | Description                                                |
|-----------|------------------------------------------------------------|
| `all`     | Creates data directories and starts all services           |
| `down`    | Stops and removes all containers (volumes preserved)       |
| `clean`   | Alias for `down`                                           |
| `fclean`  | Stops containers and removes all volumes (data deleted)    |
| `re`      | Full rebuild: `fclean` + `all`                             |

---

## Docker Compose

The `docker-compose.yml` is located in `srcs/`. All commands are wrapped by the Makefile, but can also be run directly:

```bash
# Start
docker compose -f srcs/docker-compose.yml up --build -d

# Stop
docker compose -f srcs/docker-compose.yml down

# View logs for a service
docker compose -f srcs/docker-compose.yml logs -f <service>

# Open a shell in a container
docker compose -f srcs/docker-compose.yml exec <service> bash

# Check container status
docker compose -f srcs/docker-compose.yml ps
```

### Services

| Service       | Base image       | Role                              |
|---------------|------------------|-----------------------------------|
| `nginx`       | debian:bookworm  | Reverse proxy, TLS termination    |
| `wordpress`   | debian:bookworm  | PHP-FPM + WordPress               |
| `mariadb`     | debian:bookworm  | Database                          |
| `redis`       | debian:bookworm  | WordPress object cache            |
| `adminer`     | debian:bookworm  | Database web UI                   |
| `ftp`         | debian:bookworm  | FTP access to WordPress volume    |
| `static-site` | debian:bookworm  | Static HTML/CSS showcase          |
| `uptime-kuma` | debian:bookworm  | Service monitoring                |

All containers share the `inception` bridge network.

---

## Data persistence

Two Docker volumes are used, both bound to the host filesystem:

| Volume          | Host path                    | Container path              |
|-----------------|------------------------------|-----------------------------|
| `wordpress_data`| `/home/sberete/data/wordpress` | `/var/www/html` (WordPress, NGINX, FTP) |
| `mariadb_data`  | `/home/sberete/data/mariadb`   | `/var/lib/mysql` (MariaDB)  |

The directories are created automatically by `make all`. Data persists across container restarts and `make down`. Only `make fclean` deletes the Docker volumes (the bind-mounted directories on the host remain).

---

## SSL/TLS

NGINX generates a self-signed certificate at build time using OpenSSL. The certificate covers both `sberete.42.fr` and `kuma.sberete.42.fr` via Subject Alternative Names (SAN). Only TLS 1.2 and 1.3 are enabled.

---

## WordPress initialization

On first start, the WordPress container (`init.sh`):
1. Waits for MariaDB to be ready
2. Downloads WordPress core via WP-CLI
3. Creates `wp-config.php` with the correct DB credentials
4. Runs the WordPress installer
5. Creates the admin and author user accounts
6. Configures and activates the Redis cache plugin

---

## MariaDB initialization

On first start, the MariaDB container (`init.sh`):
1. Initializes the data directory if empty
2. Starts MariaDB temporarily without networking
3. Creates the database and user defined in `.env`
4. Grants privileges and shuts down
5. Restarts MariaDB with network binding on port 3306
