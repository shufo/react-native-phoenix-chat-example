# constants
PROJECT = chat
CURRENT_DIR = $(shell pwd | sed -e "s/\/cygdrive//g")
DOCKER_MACHINE_NAME = default
DOCKER_MACHINE_CPU = 4
DOCKER_MACHINE_MEMORY = 4096

.PHONY: install
ifeq (install,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
# boot containers
install: ## Create VM and containers : ## make install
	@echo "===> Install started... \n\n" && \
	[ $(docker-machine status $(DOCKER_MACHINE_NAME)) ] || \
	docker-machine create -d virtualbox \
			--virtualbox-cpu-count $(DOCKER_MACHINE_CPU) \
			--virtualbox-memory $(DOCKER_MACHINE_MEMORY) \
			$(DOCKER_MACHINE_NAME) || true && \
	echo "===> Copy .env file...\n\n" && \
	cp .env.local.example .env && \
	eval $(docker-machine env $(DOCKER_MACHINE_NAME)) && \
	echo "===> Run npm install..." && \
	echo $(CURRENT_DIR) && \
	docker run --rm -v $(CURRENT_DIR):/app -w /app node npm install && \
	echo "===> Run composer install..." && \
	docker run --rm -v $(CURRENT_DIR):/app -v ~/.composer:/root/.composer -w /app composer/composer install && \
	echo "===> Create containers..." && \
	docker-compose -f docker-compose.yml -p $(PROJECT) up -d && \
	docker run --rm --volumes-from $(PROJECT)_app -w /app \
	--net $(PROJECT)_default --link $(PROJECT)_mysql:mysql \
	$(PROJECT)_app migrate --force --seed

# remove virtual machine
destroy: ## Warn! Destroy virtual machine : ## make destroy
	docker-machine rm -f $(DOCKER_MACHINE_NAME)

.PHONY: build
ifeq (build,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
build: ## Build containers : ## make build, make build app
	docker-compose -f docker-compose.yml -p $(PROJECT) build $(RUN_ARGS)

.PHONY: logs
ifeq (logs,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
logs: ## Display container's log : ## make logs, make logs app
	docker-compose -f docker-compose.yml -p $(PROJECT) logs $(RUN_ARGS)

.PHONY: run
ifeq (run,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
run: ## Run a one-off command : ## make run app echo hello
	docker-compose -f docker-compose.yml -p $(PROJECT) run -d $(RUN_ARGS)

.PHONY: up
ifeq (up,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
up: ## Create and start containers : ## make up, make up mysql
	docker-compose -f docker-compose.yml -p $(PROJECT) up -d $(RUN_ARGS)

.PHONY: kill
ifeq (kill,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
kill: ## kill containers : ## make kill, make kill mysql
	docker-compose -f docker-compose.yml -p $(PROJECT) kill $(RUN_ARGS)

.PHONY: rm
ifeq (rm,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
rm: ## Stop & Remove containers : ## make rm, make rm mysql
	docker-compose -f docker-compose.yml -p $(PROJECT) kill $(RUN_ARGS) && \
	docker-compose -f docker-compose.yml -p $(PROJECT) rm -f $(RUN_ARGS)

ps: ## List containers : ## make ps
	docker-compose -f docker-compose.yml -p $(PROJECT) ps

.PHONY: restart
ifeq (restart,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
restart: ## Restart services : ## make restart, make restart app
	docker-compose -f docker-compose.yml -p $(PROJECT) kill $(RUN_ARGS) && \
	docker-compose -f docker-compose.yml -p $(PROJECT) rm -f $(RUN_ARGS) && \
	docker-compose -f docker-compose.yml -p $(PROJECT) up -d $(RUN_ARGS)

.PHONY: recreate
ifeq (recreate,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
recreate: ## Recreate services  : ## make recreate
	docker-compose -f docker-compose.yml -p $(PROJECT) kill $(RUN_ARGS) && \
	docker-compose -f docker-compose.yml -p $(PROJECT) rm -f $(RUN_ARGS) && \
	docker-compose -f docker-compose.yml -p $(PROJECT) build $(RUN_ARGS) && \
	docker-compose -f docker-compose.yml -p $(PROJECT) up -d $(RUN_ARGS)

.PHONY: test
ifeq (test,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
test: ## Test all assertions : ## make test
	docker exec -i $(PROJECT)_app mix test

.PHONY: mix-get
ifeq (mix-get,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
mix-get: ## Get mix dependencies : ## make mix-get
	docker exec -i $(PROJECT)_app mix deps.get

.PHONY: routes
ifeq (routes,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
routes: ## List all phoenix routes : ## make routes
	docker exec -i $(PROJECT)_app mix phoenix.routes

.PHONY: attach
ifeq (attach,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
attach: ## Attach to container : ## make attach app
	docker exec -i $(PROJECT)_$(RUN_ARGS) /bin/bash

.PHONY: redis-monitor
ifeq (redis-monitor,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
redis-monitor: ## Monitor redis command : ## make redis-monitor
	docker exec -i $(PROJECT)_redis redis-cli monitor

.PHONY: redis-cli
ifeq (redis-cli,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
redis-cli: ## Attach to redis-cli : ## make redis-cli
	docker exec -i $(PROJECT)_redis sh -c "redis-cli"

.PHONY: redis-info
ifeq (redis-info,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
redis-info: ## Show redis info : ## make redis-info
	docker exec -i $(PROJECT)_redis sh -c "redis-cli info"

.PHONY: help
help: ## Show this help message : ## make help
	@echo -e "\nUsage: make [command] [args]\n"
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ": ## "}; {printf "\t\033[36m%-20s\033[0m \033[33m%-30s\033[0m (e.g. \033[32m%s\033[0m)\n", $$1, $$2, $$3}'
	@echo -e "\n"

.DEFAULT_GOAL := help
