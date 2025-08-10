# AUGMENTCODE.md

This document provides a comprehensive technical overview of the `zsh-dotfiles-prep` repository for AI assistants and developers working with this codebase.

## Repository Overview

**Purpose**: A prerequisite installation system that prepares development environments for the [bossjones/zsh-dotfiles](https://github.com/bossjones/zsh-dotfiles) chezmoi configuration. This repository acts as a bootstrap layer that installs essential development tools before applying dotfiles.

**Architecture**: Multi-platform installer supporting macOS, Debian/Ubuntu, and CentOS/RHEL systems with comprehensive CI/CD testing across multiple architectures (linux/amd64, linux/arm64).

## Core Components

### Installation Scripts (`/bin/`)

1. **`install.sh`** - POSIX-compliant meta-installer
   - Platform detection (macOS/Linux distribution identification)
   - Dependency installation (curl, git, build tools)
   - Delegates to platform-specific installers
   - Handles command-line arguments (`--overwrite`, `--debug`)

2. **`zsh-dotfiles-prereq-installer`** - macOS-specific installer
   - Homebrew installation and configuration
   - Xcode Command Line Tools setup
   - TouchID sudo authentication configuration
   - Brewfile processing for package management
   - Software update management

3. **`zsh-dotfiles-prereq-installer-linux`** - Cross-platform Linux installer
   - Package manager abstraction (apt/dnf)
   - Distribution-specific package installation
   - Development toolchain setup
   - Environment compatibility layer creation

### Development Toolchain Installation

Both platform installers install a comprehensive development environment:

- **Version Managers**: asdf (v0.11.2), pyenv, fnm (Node.js), rbenv
- **Languages**: Python 3.12, Node.js (v22.x), Rust/Cargo, Go 1.20.5, Ruby
- **Development Tools**: Git, curl, cmake, build-essential packages
- **Shell Enhancement**: zsh, fzf, ripgrep, neovim, various CLI utilities
- **Dotfiles Manager**: chezmoi (v2.31.1) for configuration management

### Environment Compatibility System

The installers create compatibility files that ensure consistent environment setup:

- **`~/compat.bash`** - Bash-specific environment configuration
- **`~/compat.sh`** - POSIX shell-compatible configuration

These files handle:
- PATH configuration for all installed tools
- Homebrew environment setup (macOS)
- Version manager initialization (pyenv, fnm, asdf)
- Platform-specific environment variables

## Multi-Platform Testing Infrastructure

### Docker-Based Testing

Three Dockerfiles provide comprehensive testing coverage:

- **`Dockerfile-debian-12`** - Debian 12 environment
- **`Dockerfile-ubuntu-2204`** - Ubuntu 22.04 environment
- **`Dockerfile-centos-9`** - CentOS 9/RHEL environment

Each supports multi-architecture builds (linux/amd64, linux/arm64) and publishes to GitHub Container Registry.

### GitHub Configuration (`.github/`)

The repository includes comprehensive GitHub-specific configurations for automation, security, and development workflow management:

#### Workflows (`.github/workflows/`)

1. **`tests-e2e.yml`** - End-to-end testing pipeline
   - **Matrix Strategy**: Tests across Debian 12, Ubuntu 22.04, and CentOS 9
   - **Multi-Architecture**: Supports linux/amd64 and linux/arm64 builds
   - **Container Publishing**: Automated publishing to GitHub Container Registry on main branch
   - **Debug Integration**: tmate debugging sessions for troubleshooting
   - **Permissions**: Granular permissions for contents, packages, and security events

2. **`tests.yml`** - Core CI pipeline
   - **Style Validation**: shellcheck and shfmt formatting checks
   - **Cross-Platform Testing**: macOS native and Linux container testing
   - **Concurrency Control**: Prevents duplicate workflow runs
   - **Manual Dispatch**: Supports manual triggering with debug options

3. **`actionlint.yml`** - Workflow security and syntax validation
   - **Security Auditing**: Uses zizmor for GitHub Actions security analysis
   - **SARIF Integration**: Generates and uploads security findings
   - **Repository Restriction**: Only runs for bossjones organization
   - **Artifact Management**: Handles security report uploads and downloads

4. **`tmate.yml`** / **`tmate-mac.yml`** - Interactive debugging workflows
   - **Remote Debugging**: SSH-like access to GitHub Actions runners
   - **Platform-Specific**: Separate workflows for Linux and macOS debugging
   - **Manual Trigger**: Workflow dispatch with debug flag control
   - **Access Control**: Limited to repository actors for security

#### Repository Configuration Files

1. **`dependabot.yml`** - Automated dependency management
   - **GitHub Actions Updates**: Weekly updates for workflow dependencies
   - **Grouping Strategy**: Groups related artifacts for cleaner PRs
   - **Ignore Patterns**: Excludes specific dependencies (actions/stale)
   - **Sync Management**: File synced from central `.github` repository

2. **`actionlint.yaml`** - Workflow linting configuration
   - **Error Filtering**: Ignores specific shellcheck warnings (SC2086, SC2129)
   - **Path-Specific Rules**: Targets `.github/workflows/` directory
   - **Self-Hosted Runner Config**: Placeholder for future self-hosted runners

### Quality Assurance and Security

#### Code Quality Tools
- **`contrib/style.sh`** - Shell script linting and formatting
  - shellcheck for static analysis and security checks
  - shfmt for consistent formatting with 2-space indentation
  - Automatic fix mode (`--fix` flag) with patch application
  - Integration with CI/CD for automated validation

#### Security Configuration
- **`zizmor.yml`** - GitHub Actions security auditing configuration
  - **Action Pinning Policies**: Enforces hash-pinning for third-party actions
  - **Reference Pinning**: Allows ref-pinning for trusted actions (GitHub, Docker, Homebrew)
  - **Forbidden Actions**: Blocks dangerous or untrusted action organizations
  - **Template Injection Protection**: Monitors for unsafe variable interpolation
  - **Severity Configuration**: Configurable warning levels for different audit types

#### Development Automation
- **`.pre-commit-config.yaml`** - Pre-commit hooks configuration
  - **Multi-Stage Hooks**: pre-commit, commit-msg, pre-push, post-checkout, post-merge
  - **Text Processing**: Smart quote fixing, ligature normalization, CODEOWNERS alphabetization
  - **Code Formatting**: Prettier for YAML/JSON, various language-specific formatters
  - **Security Scanning**: Integration with security analysis tools

#### Dependency Management
- **Dependabot Integration**: Automated weekly updates for GitHub Actions
- **Artifact Grouping**: Intelligent grouping of related dependency updates
- **Selective Updates**: Configured ignore patterns for specific dependencies

## Package Management Strategy

### macOS (Homebrew)
- **`Brewfile`** - Comprehensive package manifest (500+ packages)
  - Development tools, languages, utilities
  - Fonts (Nerd Fonts collection)
  - VSCode extensions
  - GUI applications (casks)

### Linux (Native Package Managers)
- **Debian/Ubuntu**: apt-get with build-essential and development libraries
- **CentOS/RHEL**: dnf with EPEL repository and Development Tools group
- **Oracle Linux**: Special handling for CodeReady Builder repository

## Environment Variables and Configuration

#### Core Configuration
```bash
ZSH_DOTFILES_PREP_GITHUB_USER=bossjones  # GitHub username for Brewfile fetching
ZSH_DOTFILES_PREP_DEBUG=1                # Enable debug output
ZSH_DOTFILES_PREP_CI=1                   # CI environment flag
ZSH_DOTFILES_PREP_SKIP_BREW_BUNDLE=0     # Skip Brewfile installation
ZSH_DOTFILES_PREP_SKIP_SOFTWARE_UPDATES=0 # Skip macOS software updates
```

#### Git Configuration
```bash
ZSH_DOTFILES_PREP_GIT_NAME="Your Name"
ZSH_DOTFILES_PREP_GIT_EMAIL="your@email.com"
ZSH_DOTFILES_PREP_GITHUB_USER="username"
```

#### CI/CD Environment Variables
```bash
REGISTRY=ghcr.io                         # Container registry URL
REGISTRY_OWNER=bossjones                 # Registry namespace
REGISTRY_IMAGE=bossjones/zsh-dotfiles-prep # Full image name
DEBIAN_FRONTEND=noninteractive           # Prevent interactive prompts
CR_PAT=<token>                          # GitHub Personal Access Token for registry
HOMEBREW_DEVELOPER=1                     # Homebrew developer mode
HOMEBREW_NO_AUTO_UPDATE=1               # Disable automatic Homebrew updates
HOMEBREW_NO_ENV_HINTS=1                 # Disable Homebrew environment hints
```

## Usage Patterns

### Remote Installation (Recommended)
```bash
export ZSH_DOTFILES_PREP_GITHUB_USER=bossjones
curl -fsSL https://raw.githubusercontent.com/bossjones/zsh-dotfiles-prep/main/bin/zsh-dotfiles-prereq-installer | bash -s -- --debug
```

### Local Development
```bash
git clone https://github.com/bossjones/zsh-dotfiles-prep.git
cd zsh-dotfiles-prep
./install.sh --debug
```

### Docker Testing
```bash
make docker-buildx DOCKERFILE=Dockerfile-debian-12 IMAGE_TAG=debian-12
make docker-run-test IMAGE_TAG=debian-12
```

## Integration with zsh-dotfiles

This repository prepares the environment for the main [bossjones/zsh-dotfiles](https://github.com/bossjones/zsh-dotfiles) repository by:

1. **Installing chezmoi** - The dotfiles management tool
2. **Setting up version managers** - For language runtime management
3. **Creating compatibility layers** - For consistent shell environments
4. **Installing development tools** - Required by dotfiles configurations

After this preparation, users run:
```bash
chezmoi init -R --debug -v --apply https://github.com/bossjones/zsh-dotfiles.git
```

## Security Considerations

- **Sudo handling** - Secure password prompting and TouchID integration
- **Script validation** - Comprehensive shellcheck linting
- **Workflow security** - zizmor auditing for GitHub Actions
- **Minimal privilege** - Scripts avoid running as root where possible

## Development Workflow

### Local Development Process
1. **Primary Development** - Development on macOS with cross-platform validation
2. **Style Checking** - `make style` for linting and formatting validation
3. **Pre-commit Hooks** - `make install-hooks` sets up automated quality checks
4. **Cross-Platform Testing** - Docker-based validation across Linux distributions
5. **CI/CD Integration** - Automated testing and publishing pipeline

### Makefile Integration with GitHub Workflows
The repository's Makefile provides commands that mirror CI/CD operations:

```bash
# Quality assurance (matches CI style job)
make style                    # Run shellcheck and shfmt validation
make style-fix               # Auto-fix formatting issues

# GitHub Actions workflow validation
make lint-gh-actions         # Run zizmor security auditing on workflows

# Docker operations (matches CI container jobs)
make docker-buildx           # Build multi-architecture containers
make docker-run-test         # Test containers locally
make docker-full-pipeline    # Complete build, test, and publish cycle

# Development environment setup
make install-hooks           # Set up Python venv and pre-commit hooks
make ghcr-login             # Authenticate with GitHub Container Registry
```

### CI/CD Pipeline Flow
1. **Pull Request Triggers** - Style checks and cross-platform testing
2. **Main Branch Pushes** - Full testing plus container publishing
3. **Manual Dispatch** - Debug workflows with tmate access
4. **Security Auditing** - Continuous workflow security validation
5. **Dependency Updates** - Automated Dependabot PRs for GitHub Actions

This repository serves as a critical foundation layer, ensuring consistent and reliable development environment setup across multiple platforms before applying personalized dotfiles configurations.

## Technical Implementation Details

### Script Architecture Patterns

The installers follow a consistent pattern:

1. **Platform Detection** - OS and architecture identification
2. **Prerequisite Validation** - Check for required tools (curl, git, sudo)
3. **Package Manager Setup** - Install/configure Homebrew (macOS) or validate apt/dnf (Linux)
4. **Development Toolchain** - Install languages, version managers, and build tools
5. **Environment Configuration** - Create compatibility files and PATH setup
6. **Validation** - Verify installations and provide next steps

### Error Handling and Logging

- **Trap-based cleanup** - Ensures temporary files are removed on exit
- **Step tracking** - `ZSH_DOTFILES_PREP_STEP` variable tracks current operation
- **Debug mode** - Comprehensive logging with `set -x` when `--debug` flag is used
- **Colored output** - User-friendly status messages with color coding
- **Failure reporting** - Clear error messages with troubleshooting guidance

### Idempotency and Safety

- **Existence checks** - All installations check if tools are already present
- **Backup creation** - `take_backup()` function preserves existing configurations
- **Non-destructive operations** - Scripts avoid overwriting existing setups
- **Sudo validation** - TouchID integration and secure password handling
- **CI environment detection** - Special handling for automated environments

### Cross-Platform Compatibility

#### macOS Specifics
- **Architecture detection** - Intel vs Apple Silicon Homebrew paths
- **Xcode Command Line Tools** - Automated installation and license agreement
- **Security settings** - TouchID sudo configuration
- **Software updates** - Optional macOS system update management

#### Linux Distribution Handling
- **Package manager abstraction** - Unified interface for apt/dnf operations
- **Repository management** - EPEL for CentOS/RHEL, PPA for Ubuntu
- **Dependency resolution** - Distribution-specific package names
- **Symlink management** - Handle package naming differences (fd/fdfind)

### Container Infrastructure

#### Multi-Stage Builds
Each Dockerfile follows a pattern:
1. **Base system update** - Package manager refresh and essential tools
2. **User creation** - Non-root user for security
3. **Environment setup** - Locale, timezone, and shell configuration
4. **Installer execution** - Run the platform-specific installer
5. **Validation** - Verify successful installation

#### Registry Management
- **GitHub Container Registry** - Automated publishing on main branch
- **Multi-architecture support** - linux/amd64 and linux/arm64 builds
- **Caching strategy** - GitHub Actions cache for faster builds
- **Tagging scheme** - Platform-specific tags with git commit hashes
- **Authentication** - CR_PAT token-based authentication via `hack/docker-login.sh`
- **Conditional Publishing** - Only publishes on successful test completion

### Testing Strategy

#### Unit Testing
- **Shell script validation** - shellcheck static analysis
- **Format consistency** - shfmt formatting verification
- **Syntax validation** - Bash/POSIX compliance checking

#### Integration Testing
- **Container testing** - Full installer execution in isolated environments
- **Native testing** - macOS runner validation
- **Matrix testing** - Multiple OS/architecture combinations
- **Regression testing** - Dual installer runs to verify idempotency

#### Security Testing
- **Workflow auditing** - zizmor security analysis
- **SARIF reporting** - Security findings integration with GitHub
- **Dependency scanning** - Automated vulnerability detection

### Performance Optimizations

- **Parallel operations** - Background processes where safe (caffeinate)
- **Caching strategies** - Homebrew cache, GitHub Actions cache
- **Minimal downloads** - Only install required packages
- **Efficient package management** - Batch operations where possible

### Extensibility Points

- **Custom Brewfiles** - User-specific package management via GitHub repos
- **Environment variable overrides** - Configurable behavior
- **Hook system** - `run_dotfile_scripts()` for custom extensions
- **Modular design** - Platform-specific functions for easy modification

## Troubleshooting and Debugging

### Common Issues
- **Permission problems** - Sudo access and TouchID configuration
- **Network connectivity** - Package download failures
- **Platform detection** - Unsupported OS/distribution handling
- **Version conflicts** - Existing tool version management

### Debug Tools
- **Verbose logging** - `--debug` flag for detailed output
- **Interactive debugging** - tmate sessions in CI/CD
- **Container inspection** - Docker logs and interactive shells
- **Environment validation** - Tool version checking and PATH verification

### Maintenance Considerations
- **Version pinning** - Specific tool versions for reproducibility
- **Dependency updates** - Regular package version updates
- **Platform support** - Adding new OS/distribution support
- **Security updates** - Regular security patch application
