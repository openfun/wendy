# -- Docker
# Get the current user ID to use for docker run and docker exec commands
DOCKER_UID           = $(shell id -u)
DOCKER_GID           = $(shell id -g)
DOCKER_USER          = $(DOCKER_UID):$(DOCKER_GID)
COMPOSE              = DOCKER_USER=$(DOCKER_USER) docker compose
COMPOSE_RUN          = $(COMPOSE) run --rm

# ==============================================================================
# RULES

default: help

# -- Docker/compose
bootstrap: ## bootstrap project
bootstrap: \
	build \
	pairing \
	run
.PHONY: bootstrap

build: ## build custom jupyter notebook image
	@$(COMPOSE) build notebook
.PHONY: build

down: ## stop and remove backend containers
	@$(COMPOSE) down
.PHONY: down


lint-black: ## lint back-end python sources with black
	@echo 'lint:black started…'
	bin/jupytext --sync --pipe black notebooks/**
.PHONY: lint-black

logs: ## display app logs (follow mode)
	@$(COMPOSE) logs -f notebook
.PHONY: logs

pairing: ## activatsynchronize notebooks
	bin/jupytext --sync notebooks/**
.PHONY: pairing

pre-commit: ## install pre-commit hooks
	$(COMPOSE_RUN) pre-commit bash -c "pip install pre-commit" \
	bin/pre-commit install
.PHONY: pre-commit


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
