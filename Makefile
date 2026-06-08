COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	mkdir -p /home/sberete/data/wordpress /home/sberete/data/mariadb
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down -v

re: fclean all

.PHONY: all down clean fclean re