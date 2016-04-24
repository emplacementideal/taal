TAG := dev

.DEFAULT: help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build Taal Docker image
	@docker build -t pentimentolabs/taal:$(TAG) .

.PHONY: push
push: ## Publish Taal image to Docker Hub
	@docker push pentimentolabs/taal:$(TAG)

.PHONY: run
run: ## Run a Docker container from the Taal image
	@docker run --rm -it pentimentolabs/taal:$(TAG)
