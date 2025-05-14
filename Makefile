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
