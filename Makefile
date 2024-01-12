# -- Docker
# Get the current user ID to use for docker run and docker exec commands
DOCKER_UID           = $(shell id -u)
DOCKER_GID           = $(shell id -g)
DOCKER_USER          = $(DOCKER_UID):$(DOCKER_GID)
COMPOSE              = DOCKER_USER=$(DOCKER_USER) docker compose
COMPOSE_RUN          = $(COMPOSE) run --rm
COMPOSE_RUN_NOTEBOOK = $(COMPOSE_RUN) notebook

# ==============================================================================
# RULES

default: help

# -- Docker/compose
bootstrap: ## bootstrap project
bootstrap: \
	build \
	run
.PHONY: bootstrap

build: ## build custom jupyter notebook image
	@$(COMPOSE) build notebook
.PHONY: build

down: ## stop and remove backend containers
	@$(COMPOSE) down
.PHONY: down

lint: ## lint notebook with nbqa
	@echo 'lint:ruff started…'
	# @$(COMPOSE_RUN_NOTEBOOK) nbqa ruff notebooks
	@echo 'lint:black started…'
	@$(COMPOSE_RUN_NOTEBOOK) nbqa black notebooks
.PHONY: lint

lint-fix: ## lint and fix notebook errors with nbqa
	@echo 'lint:ruff started…'
	@$(COMPOSE_RUN_NOTEBOOK) nbqa ruff --fix notebooks
.PHONY: lint-fix

logs: ## display app logs (follow mode)
	@$(COMPOSE) logs -f notebook
.PHONY: logs

run: ## run notebook server
run:
	@$(COMPOSE) up -d notebook
.PHONY: run

status: ## an alias for "docker compose ps"
	@$(COMPOSE) ps
.PHONY: status

stop: ## stops backend servers
stop:
	@$(COMPOSE) stop
.PHONY: stop

# -- Misc
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
