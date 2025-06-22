#!/bin/sh
# install.sh - POSIX-compliant installer for zsh-dotfiles-prep dependencies
# Works on macOS and Linux (Debian/Ubuntu/CentOS/RHEL)

set -e

# Global variables
OVERWRITE_GO=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  printf "${GREEN}[INFO]${NC} %s\n" "$1"
}

log_warn() {
  printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_error() {
  printf "${RED}[ERROR]${NC} %s\n" "$1"
}

log_debug() {
  if [ "${ZSH_DOTFILES_PREP_DEBUG:-0}" = "1" ]; then
    printf "${BLUE}[DEBUG]${NC} %s\n" "$1"
  fi
}

# Platform detection
detect_platform() {
  case "$(uname -s)" in
  Darwin*)
    PLATFORM="macos"
    ;;
  Linux*)
    PLATFORM="linux"
    # Detect specific Linux distribution
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      case "$ID" in
      debian | ubuntu)
        LINUX_DISTRO="$ID"
        ;;
      centos | rhel | rocky | almalinux | ol)
        LINUX_DISTRO="centos"
        ;;
      *)
        log_error "Unsupported Linux distribution: $ID"
        log_error "This script only supports Debian, Ubuntu, and CentOS/RHEL-based distributions"
        exit 1
        ;;
      esac
    else
      log_error "Cannot detect Linux distribution"
      exit 1
    fi
    ;;
  *)
    log_error "Unsupported platform: $(uname -s)"
    log_error "This script only supports macOS and Linux"
    exit 1
    ;;
  esac
  log_info "Detected platform: $PLATFORM"
  if [ "$PLATFORM" = "linux" ]; then
    log_info "Linux distribution: $LINUX_DISTRO"
  fi
}

# Set default environment variables (from GitHub Actions workflows)
set_default_env_vars() {
  log_info "Setting default environment variables"

  # Core environment variables
  export DEBIAN_FRONTEND="${DEBIAN_FRONTEND:-noninteractive}"
  export ZSH_DOTFILES_PREP_CI="${ZSH_DOTFILES_PREP_CI:-1}"
  export ZSH_DOTFILES_PREP_DEBUG="${ZSH_DOTFILES_PREP_DEBUG:-1}"
  export ZSH_DOTFILES_PREP_GITHUB_USER="${ZSH_DOTFILES_PREP_GITHUB_USER:-bossjones}"
  export ZSH_DOTFILES_PREP_SKIP_BREW_BUNDLE="${ZSH_DOTFILES_PREP_SKIP_BREW_BUNDLE:-0}"
  export ZSH_DOTFILES_PREP_SKIP_SOFTWARE_UPDATES="${ZSH_DOTFILES_PREP_SKIP_SOFTWARE_UPDATES:-0}"

  # Homebrew environment variables
  export HOMEBREW_DEVELOPER="${HOMEBREW_DEVELOPER:-1}"
  export HOMEBREW_NO_AUTO_UPDATE="${HOMEBREW_NO_AUTO_UPDATE:-1}"
  export HOMEBREW_NO_ENV_HINTS="${HOMEBREW_NO_ENV_HINTS:-1}"

  # Locale settings
  export LANG="${LANG:-en_US.UTF-8}"
  export LANGUAGE="${LANGUAGE:-en_US:en}"
  export LC_ALL="${LC_ALL:-en_US.UTF-8}"

  log_debug "Environment variables set"
}

# Check if running as root
check_root() {
  if [ "$(id -u)" = "0" ]; then
    log_error "This script should not be run as root"
    log_error "Please run as a regular user with sudo privileges"
    exit 1
  fi
}

# Parse command line arguments
parse_args() {
  while [ $# -gt 0 ]; do
    case $1 in
    --overwrite)
      OVERWRITE_GO=1
      log_info "--overwrite flag set: Will overwrite existing Go installation"
      shift
      ;;
    --help | -h)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --overwrite    Force overwrite existing Go installation"
      echo "  --help, -h     Show this help message"
      exit 0
      ;;
    *)
      log_error "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
    esac
  done
}

# Check prerequisites
check_prerequisites() {
  log_info "Checking prerequisites"

  # Check for sudo access
  if ! sudo -n true 2>/dev/null; then
    log_info "Testing sudo access (you may be prompted for password)"
    if ! sudo true; then
      log_error "This script requires sudo access"
      exit 1
    fi
  fi

  # Check for curl
  if ! command -v curl >/dev/null 2>&1; then
    log_error "curl is required but not installed"
    exit 1
  fi

  # Check for git
  if ! command -v git >/dev/null 2>&1; then
    log_error "git is required but not installed"
    exit 1
  fi
}

# Install macOS dependencies
install_macos_deps() {
  log_info "Installing macOS dependencies"

  # Install Xcode Command Line Tools if not present
  if ! xcode-select -p >/dev/null 2>&1; then
    log_info "Installing Xcode Command Line Tools"
    xcode-select --install
    log_info "Please complete the Xcode Command Line Tools installation and run this script again"
    exit 0
  fi

  # Install Homebrew if not present
  if ! command -v brew >/dev/null 2>&1; then
    log_info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    if [ -f "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  # Update Homebrew
  log_info "Updating Homebrew"
  brew update

  # Install essential packages
  log_info "Installing essential packages via Homebrew"
  packages="python@3.12 go@1.20 zsh fish elvish shellcheck shfmt"

  for package in $packages; do
    if ! brew list "$package" >/dev/null 2>&1; then
      log_info "Installing $package"
      brew install "$package"
    else
      log_debug "$package already installed"
    fi
  done

  # Install actionlint and zizmor for CI/CD tools
  if ! command -v actionlint >/dev/null 2>&1; then
    log_info "Installing actionlint"
    brew install actionlint
  fi

  if ! command -v zizmor >/dev/null 2>&1; then
    log_info "Installing zizmor"
    brew install zizmor
  fi
}

# Install Debian/Ubuntu dependencies
install_debian_deps() {
  log_info "Installing Debian/Ubuntu dependencies"

  # Update package lists
  log_info "Updating package lists"
  sudo apt-get update

  # Configure locales
  log_info "Configuring locales"
  sudo apt-get install -y locales
  echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen >/dev/null
  sudo locale-gen
  sudo update-locale LANG=en_US.UTF-8

  # Install essential system packages
  log_info "Installing essential system packages"
  essential_packages="sudo curl wget git ca-certificates gnupg lsb-release apt-transport-https"
  sudo apt-get install -y "$essential_packages"

  # Install build tools and development libraries
  log_info "Installing build tools and development libraries"
  build_packages="build-essential g++ gcc make pkg-config llvm"
  dev_libraries="libbz2-dev libcairo2-dev libffi-dev liblzma-dev libncurses5-dev libncursesw5-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libyaml-dev python3-dev python3-openssl zlib1g-dev tk-dev"

  sudo apt-get install -y "$build_packages" "$dev_libraries"

  # Install shells and utilities
  log_info "Installing shells and utilities"
  shell_packages="zsh fish elvish zsh-doc"
  utility_packages="tree unzip vim xz-utils sqlite3 openssl procps manpages manpages-dev bash-completion gzip"

  sudo apt-get install -y "$shell_packages" "$utility_packages"

  # Install Python 3.12 if not available from system packages
  if ! command -v python3.12 >/dev/null 2>&1; then
    log_info "Installing Python 3.12"
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update
    sudo apt-get install -y python3.12 python3.12-dev python3.12-venv
  fi

  # Install Go 1.20.5 if not available or if overwrite flag is set
  if [ "$OVERWRITE_GO" = "1" ] || ! command -v go >/dev/null 2>&1 || [ "$(go version | cut -d' ' -f3)" != "go1.20.5" ]; then
    log_info "Installing Go 1.20.5"
    cd /tmp
    wget -q https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
    rm go1.20.5.linux-amd64.tar.gz
    cd -

    # Add Go to PATH (smarter check to avoid duplicates)
    if ! echo "$PATH" | grep -q "/usr/local/go/bin"; then
      # Check if the PATH export line already exists in .bashrc
      if ! grep -qF "export PATH=\$PATH:/usr/local/go/bin" "$HOME/.bashrc" 2>/dev/null; then
        echo "export PATH=\$PATH:/usr/local/go/bin" >>"$HOME/.bashrc"
        log_info "Added Go to PATH in .bashrc"
      else
        log_debug "Go PATH already exists in .bashrc"
      fi
      export PATH="$PATH":/usr/local/go/bin
    else
      log_debug "Go PATH already in current PATH"
    fi
  else
    log_info "Go 1.20.5 already installed, skipping (use --overwrite to force reinstall)"
  fi
}

# Install CentOS/RHEL dependencies
install_centos_deps() {
  log_info "Installing CentOS/RHEL dependencies"

  # Enable Oracle Linux specific repositories if detected
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ol" ]; then
      log_info "Detected Oracle Linux - enabling required repositories"

      # Try to enable CodeReady Builder repository for Oracle Linux 9+
      if sudo dnf config-manager --set-enabled ol9_codeready_builder 2>/dev/null; then
        log_info "Enabled ol9_codeready_builder repository"
      else
        log_warn "Could not enable CodeReady Builder repository - continuing without it"
      fi

      # Install EPEL for Oracle Linux
      sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm || \
      log_warn "Could not install EPEL repository"
    fi
  fi

  # Update package lists
  log_info "Updating package lists"
  sudo dnf update -y

  # Install EPEL repository for additional packages (if not already installed for Oracle Linux)
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ol" ]; then
      log_info "Installing EPEL repository"
      sudo dnf install -y epel-release
    fi
  fi

  # Configure locales
  log_info "Configuring locales"
  sudo dnf install -y glibc-locale-source glibc-langpack-en
  sudo localedef -c -i en_US -f UTF-8 en_US.UTF-8

  # Install essential system packages
  log_info "Installing essential system packages"
  essential_packages="sudo curl wget git ca-certificates gnupg gnupg2 procps-ng"
  sudo dnf install -y "$essential_packages"

  # Install build tools and development libraries
  log_info "Installing build tools and development libraries"
  sudo dnf groupinstall -y "Development Tools"
  build_packages="gcc gcc-c++ make pkgconfig llvm"
  dev_libraries="bzip2-devel cairo-devel libffi-devel xz-devel ncurses-devel libpq-devel readline-devel sqlite-devel openssl-devel python3-devel zlib-devel tk-devel libevent-devel xmlsec1-devel xmlsec1-openssl-devel libyaml-devel xvidcore-devel"

  sudo dnf install -y "$build_packages" "$dev_libraries"

  # Install shells and utilities
  log_info "Installing shells and utilities"
  shell_packages="zsh fish"
  utility_packages="tree unzip vim xz sqlite openssl procps-ng man-pages bash-completion gzip"

  sudo dnf install -y "$shell_packages" "$utility_packages"

  sudo dnf install --enablerepo=ol9_codeready_builder libyaml-devel libevent-devel openssl-devel readline-devel ncurses-devel zlib-devel bzip2-devel libffi-devel -y

  # Install Oracle Linux specific packages that need special handling
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ol" ]; then
      log_info "Installing Oracle Linux specific packages"

      # Install direnv via binary installer
      if ! command -v direnv >/dev/null 2>&1; then
        log_info "Installing direnv via binary installer"
        curl -sfL https://direnv.net/install.sh | bash
      fi

      # Try to install bzr from EPEL
      log_info "Attempting to install bzr"
      sudo dnf install -y bzr || log_warn "bzr not available, consider pip install bzr"

      # Download and install AtomicParsley manually
      if ! command -v AtomicParsley >/dev/null 2>&1; then
        log_info "Installing AtomicParsley manually"
        cd /tmp
        wget https://github.com/wez/atomicparsley/releases/latest/download/AtomicParsleyLinux.zip
        unzip AtomicParsleyLinux.zip
        sudo mv AtomicParsley /usr/local/bin/
        sudo chmod +x /usr/local/bin/AtomicParsley
        cd -
      fi
    fi
  fi

  # Install Python 3.12 if not available from system packages
  if ! command -v python3.12 >/dev/null 2>&1; then
    log_info "Installing Python 3.12"
    sudo dnf install -y python3.12 python3.12-devel python3.12-pip
  fi

  # Install Go 1.20.5 if not available or if overwrite flag is set
  if [ "$OVERWRITE_GO" = "1" ] || ! command -v go >/dev/null 2>&1 || [ "$(go version | cut -d' ' -f3)" != "go1.20.5" ]; then
    log_info "Installing Go 1.20.5"
    cd /tmp
    wget -q https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
    rm go1.20.5.linux-amd64.tar.gz
    cd -

    # Add Go to PATH (smarter check to avoid duplicates)
    if ! echo "$PATH" | grep -q "/usr/local/go/bin"; then
      # Check if the PATH export line already exists in .bashrc
      if ! grep -qF "export PATH=\$PATH:/usr/local/go/bin" "$HOME/.bashrc" 2>/dev/null; then
        echo "export PATH=\$PATH:/usr/local/go/bin" >>"$HOME/.bashrc"
        log_info "Added Go to PATH in .bashrc"
      else
        log_debug "Go PATH already exists in .bashrc"
      fi
      export PATH="$PATH":/usr/local/go/bin
    else
      log_debug "Go PATH already in current PATH"
    fi
  else
    log_info "Go 1.20.5 already installed, skipping (use --overwrite to force reinstall)"
  fi
}

# Install Linux dependencies (wrapper function)
install_linux_deps() {
  case "$LINUX_DISTRO" in
  debian | ubuntu)
    install_debian_deps
    ;;
  centos)
    install_centos_deps
    ;;
  *)
    log_error "Unsupported Linux distribution: $LINUX_DISTRO"
    exit 1
    ;;
  esac
}

# Run the appropriate platform installer
run_platform_installer() {
  log_info "Running platform-specific installer"

  # Get the directory where this script is located
  script_dir="$(cd "$(dirname "$0")" && pwd)"

  case "$PLATFORM" in
  macos)
    installer_script="$script_dir/bin/zsh-dotfiles-prereq-installer"
    ;;
  linux)
    installer_script="$script_dir/bin/zsh-dotfiles-prereq-installer-linux"
    ;;
  esac

  if [ ! -f "$installer_script" ]; then
    log_error "Platform installer not found: $installer_script"
    log_error "Script directory: $script_dir"
    log_error "Make sure you're running this script from the repository root"
    exit 1
  fi

  # Make installer executable
  chmod +x "$installer_script"

  # Run installer with debug flag
  log_info "Running $installer_script --debug"
  "$installer_script" --debug

  # Run installer again for verification (as done in CI)
  log_info "Running installer again for verification"
  "$installer_script" --debug
}

# Main function
main() {
  log_info "Starting zsh-dotfiles-prep dependency installation"

  # Parse command line arguments
  parse_args "$@"

  # Check if not running as root
  check_root

  # Detect platform
  detect_platform

  # Set environment variables
  set_default_env_vars

  # Check prerequisites
  check_prerequisites

  # Install platform-specific dependencies
  case "$PLATFORM" in
  macos)
    install_macos_deps
    ;;
  linux)
    install_linux_deps
    ;;
  esac

  # Run the platform installer
  run_platform_installer

  log_info "Installation completed successfully!"
  log_info "Your system is now ready for bossjones/zsh-dotfiles"
  log_info ""
  log_info "Next steps:"
  log_info "1. Restart your shell or source your shell configuration"
  log_info "2. Run: chezmoi init --apply https://github.com/bossjones/zsh-dotfiles.git"
}

# Run main function
main "$@"
