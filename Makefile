.DEFAULT_GOAL:=help

COMPOSE_ALL_FILES := -f docker-compose.yaml
KEYCLOAK_SERVICES   := keycloak openldap postgres
ELK_LOG_COLLECTION := filebeat
ELK_TOOLS  := rubban
ELK_NODES := elasticsearch-1 elasticsearch-2
KEYCLOAK_MAIN_SERVICES := ${KEYCLOAK_SERVICES}

# --------------------------
all:		  	## Start keycloak and all its component.
	docker-compose ${COMPOSE_ALL_FILES} up -d --build

key:		## Start keycloak.
	docker-compose ${COMPOSE_ALL_FILES} up -d --build

up:			##
	@make key
	@echo "Visit Keycloak: https://localhost:8080"

ps:				## Show all running containers.
	@docker-compose ${COMPOSE_ALL_FILES} ps

down:			## Down keycloak and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} down

stop:			## Stop keycloak and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} stop ${KEYCLOAK_MAIN_SERVICES}
	
restart:		## Restart keycloak and all its extra components.
	@docker-compose ${COMPOSE_ALL_FILES} restart ${KEYCLOAK_MAIN_SERVICES}

rm:				## Remove keycloak and all its extra components containers.
	@docker-compose $(COMPOSE_ALL_FILES) rm -f ${KEYCLOAK_MAIN_SERVICES}

logs:			## Tail all logs with -n 1000.
	@docker-compose $(COMPOSE_ALL_FILES) logs --follow --tail=1000 ${KEYCLOAK_MAIN_SERVICES}

images:			## Show all Images of keycloak and all its extra components.
	@docker-compose $(COMPOSE_ALL_FILES) images ${KEYCLOAK_MAIN_SERVICES}

prune:			## Remove keycloak Containers and Delete keycloak-related Volume Data (the keycloak-ldap_postgres_data volume)
	@make stop && make rm
	@docker volume prune -f --filter label=com.docker.compose.project=keycloak-ldap

help:       	## Show this help.
	@echo "Make Application Docker Images and Containers using Docker-Compose files in 'docker' Dir."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m (default: help)\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)