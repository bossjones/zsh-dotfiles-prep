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

# Login to GHCR first
.PHONY: ghcr-login
ghcr-login:
	@hack/docker-login.sh
