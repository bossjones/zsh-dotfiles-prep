# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a prerequisite installation tool that prepares machines to run the [bossjones/zsh-dotfiles](https://github.com/bossjones/zsh-dotfiles) chezmoi configuration. It bootstraps development environments with essential tools before applying dotfiles.

## Quick Start

```bash
# Clone and run the complete setup
git clone https://github.com/bossjones/zsh-dotfiles-prep.git
cd zsh-dotfiles-prep
./install.sh
```

## Essential Commands

### Development and Testing
```bash
# Run code formatting and linting
make style

# Fix formatting issues automatically
make style-fix

# Set up development environment with Python venv and pre-commit hooks
make install-hooks

# Build and test Docker images for both architectures
make docker-buildx

# Run full test pipeline with Docker containers
make docker-full-pipeline

# Test individual platforms
make docker-run-test PLATFORM=debian-12
make docker-run-test PLATFORM=ubuntu-2204

# Lint GitHub Actions workflows
make lint-gh-actions

# System maintenance for Debian/Ubuntu (fixes broken packages)
make debian-fix-broken
```

### Docker Development and Debugging
```bash
# Login to GitHub Container Registry (requires CR_PAT env var)
make ghcr-login

# Build and push multi-platform images
make docker-buildx-push DOCKERFILE=Dockerfile-debian-12 IMAGE_TAG=debian-12

# Debug container with pre-configured environment
make docker-run-test-debug IMAGE_TAG=debian-12

# Interactive bash session in container
make docker-run-test-bash IMAGE_TAG=debian-12
```

### Manual Testing
```bash
# Install all dependencies and run platform installer (recommended)
./install.sh

# Test the installer scripts directly
./bin/zsh-dotfiles-prereq-installer --debug
./bin/zsh-dotfiles-prereq-installer-linux --debug

# Test in Docker containers
docker run --rm -it debian:12 bash
# Then curl and run the installer
```

## Architecture Overview

### Core Installation Scripts (`/bin/`)
- `install.sh` - POSIX-compliant meta-installer that detects platform, installs dependencies, and runs appropriate platform installer
- `zsh-dotfiles-prereq-installer` - macOS installer with Homebrew, Xcode tools, TouchID sudo
- `zsh-dotfiles-prereq-installer-linux` - Cross-platform installer for Debian/Ubuntu/CentOS

The platform installers are idempotent and install development toolchain (Rust, Python via pyenv, Node via fnm, asdf, chezmoi) plus create compatibility files (`~/compat.bash`, `~/compat.sh`) for environment setup.

### Platform Support
- **macOS**: Full support via Homebrew
- **Debian/Ubuntu**: Native package management with apt
- **CentOS/RHEL**: Native package management with dnf, EPEL repository support
- **Path Resolution**: Scripts work from any directory via absolute path detection

### Multi-Platform Testing
Docker-based testing infrastructure with `Dockerfile-debian-12` and `Dockerfile-ubuntu-2204` supporting linux/amd64 and linux/arm64 architectures. Images published to GitHub Container Registry.

### Tool Management
- `Brewfile` contains 500+ development tools including languages, utilities, fonts, and VSCode extensions
- Scripts handle version managers (pyenv, fnm, asdf) and PATH configuration
- Security-conscious with sudo pattern validation and TouchID integration

### Quality Assurance
- `contrib/style.sh` - shellcheck and shfmt for shell script linting
- `zizmor.yml` - GitHub Actions security auditing configuration
- Automated testing across OS/architecture combinations in CI/CD

## Development Workflow

1. Make changes to installer scripts in `/bin/`
2. Run `make style` to check formatting and linting
3. Test locally with `--debug` flag
4. Run `make docker-buildx` to test across platforms
5. Use `make docker-full-pipeline` for comprehensive testing before commits

## Environment Variables

### Required for Docker Registry
- `CR_PAT` - GitHub Personal Access Token for container registry authentication

### Optional Configuration
- `REGISTRY` (default: `ghcr.io`) - Container registry URL
- `REGISTRY_OWNER` (default: `bossjones`) - Registry namespace
- `DOCKERFILE` (default: `Dockerfile-debian-12`) - Which Dockerfile to use
- `IMAGE_TAG` (default: `debian-12`) - Docker image tag
- `PLATFORM` (default: `linux/amd64`) - Target platform for builds

### Test Environment Variables
- `ZSH_DOTFILES_PREP_GIT_NAME` - Git user name for testing
- `ZSH_DOTFILES_PREP_GIT_EMAIL` - Git email for testing
- `ZSH_DOTFILES_PREP_GITHUB_USER` - GitHub username for testing

## Testing Notes

The installer creates compatibility files that must work across different shell environments. Test with both bash and zsh. The `--debug` flag provides verbose output for troubleshooting installation issues.

Use `make install-hooks` to set up the Python development environment with uv and pre-commit hooks before making changes.

## Platform-Specific Notes

### CentOS/RHEL Support
Recent fixes for CentOS 9 compatibility:
- Removed unavailable packages: `yaml-devel` (no separate devel package), `elvish` (not in standard repos), `man-pages-devel` (use `man-pages`)
- Uses EPEL repository for additional packages
- Fixed path resolution to work from any directory
- Supports Oracle Linux and other RHEL derivatives

### Package Differences
- **Debian/Ubuntu**: Uses `libyaml-dev`, includes `elvish` shell
- **CentOS/RHEL**: Uses base `libyaml` package, excludes `elvish` shell
