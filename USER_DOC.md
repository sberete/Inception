# User Documentation — Inception

## Prerequisites

Before starting, make sure the following entries are in your `/etc/hosts` file:

```
127.0.0.1  sberete.42.fr
127.0.0.1  kuma.sberete.42.fr
```

---

## Starting and stopping the stack

### Start all services

```bash
make
```

This command creates the required data directories and builds and starts all containers in the background.

### Stop all services

```bash
make down
```

Stops and removes all containers. Your data (WordPress content, database) is preserved.

### Full reset

```bash
make fclean
```

Stops all containers and removes all volumes. **All data will be lost.**

### Rebuild and restart

```bash
make re
```

Equivalent to `make fclean` followed by `make`.

---

## Accessing the services

| Service         | URL                                   | Notes                        |
|-----------------|---------------------------------------|------------------------------|
| WordPress site  | https://sberete.42.fr                 | Main website                 |
| WordPress admin | https://sberete.42.fr/wp-admin        | Administration dashboard     |
| Adminer         | https://sberete.42.fr/adminer/        | Database management UI       |
| Static site     | https://sberete.42.fr/fatherfinder/   | Custom showcase site         |
| Uptime Kuma     | https://kuma.sberete.42.fr            | Service monitoring dashboard |

> **SSL warning:** A self-signed certificate is used. Your browser will display a security warning. Click "Advanced" → "Proceed" to continue.

---

## Credentials

### WordPress Admin

| Field    | Value                     |
|----------|---------------------------|
| URL      | https://sberete.42.fr/wp-admin |
| Username | `salim42`                 |
| Password | `1234`                    |
| Email    | salim@student.42.fr       |

### WordPress User (author)

| Field    | Value                     |
|----------|---------------------------|
| Username | `user42`                  |
| Password | `1234`                    |
| Email    | user42@student.42.fr      |

### MariaDB (via Adminer)

| Field    | Value       |
|----------|-------------|
| Server   | `mariadb`   |
| Username | `wpuser`    |
| Password | `1234`      |
| Database | `wordpress` |

### FTP

| Field    | Value        |
|----------|--------------|
| Host     | `localhost`  |
| Port     | `21`         |
| Username | `ftpuser`    |
| Password | `1234`       |

The FTP root points to the WordPress volume (`/home/ftpuser/wordpress`).

---

## Basic checks

### Verify all containers are running

```bash
docker compose -f srcs/docker-compose.yml ps
```

All services should show status `Up`.

### Check NGINX is only accessible on port 443

Try accessing `http://sberete.42.fr` (port 80) — it should refuse the connection. Only `https://sberete.42.fr` (port 443) should work.

### Verify TLS version

In your browser, open the developer tools → Security tab and confirm TLS 1.2 or 1.3 is in use.

### Verify data persistence

After stopping and restarting the stack with `make down` then `make`, the WordPress site and all its content should still be intact.
