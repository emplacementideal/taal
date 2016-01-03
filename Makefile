.PHONY: build run push usage
.DEFAULT: usage

TAG = dev

usage:
	@echo ""
	@echo "make build          Build Taal Docker image"
	@echo "make push           Publish Taal image to Docker Hub"
	@echo "make run            Run a Docker container from the Taal image"
	@echo ""

build:
	@docker build -t pentimento/taal:$(TAG) .

push:
	@docker push pentimento/taal:$(TAG)

run:
	@docker run --rm -it pentimento/taal:$(TAG)
