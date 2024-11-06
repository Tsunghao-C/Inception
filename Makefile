all : up

up :
	mkdir -p ${HOME}/data/mariadb_data
	mkdir -p ${HOME}/data/wordpress_data
	mkdir -p ${HOME}/data/monitoring_data/prometheus
	@docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker compose -f ./srcs/docker-compose.yml down

stop:
	@docker compose -f ./srcs/docker-compose.yml stop

start:
	@docker compose -f ./srcs/docker-compose.yml start

status:
	@docker compose -f ./srcs/docker-compose.yml ps

clean:
	docker compose -f ./srcs/docker-compose.yml down -v
	sudo rm -rf ${HOME}/data/mariadb_data
	sudo rm -rf ${HOME}/data/wordpress_data
	sudo rm -rf ${HOME}/data/monitoring_data