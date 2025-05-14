# Environment variables
REGISTRY ?= ghcr.io
REGISTRY_OWNER ?= bossjones
REGISTRY_IMAGE ?= $(REGISTRY)/$(REGISTRY_OWNER)/zsh-dotfiles-prep
DEBIAN_FRONTEND = noninteractive
DOCKERFILE ?= Dockerfile-debian-12
IMAGE_TAG ?= debian-12
PLATFORM ?= linux/amd64

.PHONY: style
style:
	contrib/style.sh

.PHONY: style-fix
style-fix:
	contrib/style.sh --fix

.PHONY: lint-gh-actions
lint-gh-actions:
	@zizmor --gh-token=$(shell gh auth token) .github/workflows/tests-e2e.yml

.PHONY: install-hooks
install-hooks:
	uv venv --python 3.12
	uv run pre-commit install

# Docker tasks
.PHONY: docker-buildx
docker-buildx:
	@if [ -z "$(DOCKERFILE)" ]; then \
		echo "Error: DOCKERFILE is not set. Usage: make docker-buildx DOCKERFILE=Dockerfile-debian-12 IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	@if [ -z "$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set. Usage: make docker-buildx DOCKERFILE=Dockerfile-debian-12 IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	@echo "Building image for platform: $(PLATFORM)"
	docker buildx build \
		--platform $(PLATFORM) \
		--file ./$(DOCKERFILE) \
		--tag zsh-dotfiles-prereq:$(IMAGE_TAG) \
		--build-arg DEBIAN_FRONTEND=$(DEBIAN_FRONTEND) \
		--load \
		.

.PHONY: docker-run-test
docker-run-test: ghcr-login
	@if [ -z "$(REGISTRY_IMAGE):$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set. Usage: make docker-run-test IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	docker run --rm --name test-container $(REGISTRY_IMAGE):$(IMAGE_TAG)
	docker logs test-container || true
	@echo "✅ Test completed"

.PHONY: docker-run-test-debug
docker-run-test-debug:
	@if [ -z "$(REGISTRY_IMAGE):$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set. Usage: make docker-run-test IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	docker run --rm --name test-container $(REGISTRY_IMAGE):$(IMAGE_TAG) bin/zsh-dotfiles-prereq-installer-linux --debug
	docker logs test-container || true
	@echo "✅ Test completed"

# Login to GHCR first
.PHONY: ghcr-login
ghcr-login:
	@bash ./hack/docker-login.sh

.PHONY: docker-buildx-push
docker-buildx-push: ghcr-login
	@if [ -z "$(DOCKERFILE)" ]; then \
		echo "Error: DOCKERFILE is not set."; \
		exit 1; \
	fi
	@if [ -z "$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set."; \
		exit 1; \
	fi
	@echo "Building and pushing multi-platform image to $(REGISTRY_IMAGE):$(IMAGE_TAG)"
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--file ./$(DOCKERFILE) \
		--tag $(REGISTRY_IMAGE):$(IMAGE_TAG) \
		--tag $(REGISTRY_IMAGE):$(IMAGE_TAG)-$(shell git rev-parse --short HEAD) \
		--build-arg DEBIAN_FRONTEND=$(DEBIAN_FRONTEND) \
		--push \
		.

# Combined task to build, test locally, and push to registry
.PHONY: docker-full-pipeline
docker-full-pipeline:
	@if [ -z "$(DOCKERFILE)" ]; then \
		echo "Error: DOCKERFILE is not set."; \
		exit 1; \
	fi
	@if [ -z "$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set."; \
		exit 1; \
	fi
	@echo "Running full Docker pipeline: build, test, and push"
	@make docker-buildx DOCKERFILE=$(DOCKERFILE) IMAGE_TAG=$(IMAGE_TAG)
	@make docker-run-test IMAGE_TAG=$(IMAGE_TAG)
	@make docker-buildx-push DOCKERFILE=$(DOCKERFILE) IMAGE_TAG=$(IMAGE_TAG)
	@echo "✅ Full Docker pipeline completed successfully"
