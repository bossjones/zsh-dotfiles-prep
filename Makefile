.PHONY: style
style:
	contrib/style.sh

.PHONY: style-fix
style-fix:
	contrib/style.sh --fix

.PHONY: lint-gh-actions
lint-gh-actions:
	@zizmor --gh-token=$(gh auth token) .github/workflows/tests-e2e.yml

.PHONY: install-hooks
install-hooks:
	uv venv --python 3.12
	uv run pre-commit install

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
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--file ./$(DOCKERFILE) \
		--tag zsh-dotfiles-prereq:$(IMAGE_TAG) \
		--load \
		.

.PHONY: docker-run-test
docker-run-test:
	@if [ -z "$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set. Usage: make docker-run-test IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	docker run --rm --name test-container zsh-dotfiles-prereq:$(IMAGE_TAG) || { \
		echo "❌ Container exited with non-zero status"; \
		docker logs test-container; \
		exit 1; \
	}
	docker logs test-container
	@echo "✅ Script completed successfully"

# Combined task to build and test
.PHONY: docker-build-and-test
docker-build-and-test:
	@if [ -z "$(DOCKERFILE)" ]; then \
		echo "Error: DOCKERFILE is not set. Usage: make docker-build-and-test DOCKERFILE=Dockerfile-debian-12 IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	@if [ -z "$(IMAGE_TAG)" ]; then \
		echo "Error: IMAGE_TAG is not set. Usage: make docker-build-and-test DOCKERFILE=Dockerfile-debian-12 IMAGE_TAG=debian-12"; \
		exit 1; \
	fi
	@echo "Building Docker image..."
	@make docker-buildx DOCKERFILE=$(DOCKERFILE) IMAGE_TAG=$(IMAGE_TAG)
	@echo "Running tests in container..."
	@make docker-run-test IMAGE_TAG=$(IMAGE_TAG)

DOCKERFILE ?= Dockerfile-debian-12
IMAGE_TAG ?= debian-12
