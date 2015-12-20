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
	@docker build -t emplacementideal/taal:$(TAG) .

push:
	@docker push emplacementideal/taal:$(TAG)

run:
	@docker run --rm -it emplacementideal/taal:$(TAG)
