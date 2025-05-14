style:
	contrib/style.sh
style-fix:
	contrib/style.sh --fix
lint-gh-actions:
	@zizmor --gh-token=$(gh auth token) .github/workflows/tests-e2e.yml
