# Quickstart Guide

This guide shows you how to quickly set up your development environment using zsh-dotfiles-prep.

## Remote Installation (Recommended)

Execute the installer directly from GitHub without cloning:

```bash
curl -fsSL https://raw.githubusercontent.com/bossjones/zsh-dotfiles-prep/main/install.sh | bash
```

This method:
- Downloads and runs the installer automatically
- Detects your platform (macOS, Debian, Ubuntu)
- Installs all prerequisites for zsh-dotfiles
- Creates compatibility files for your shell environment

## Local Installation

### 1. Clone the Repository

```bash
git clone https://github.com/bossjones/zsh-dotfiles-prep.git
cd zsh-dotfiles-prep
```

### 2. Run the Installer

```bash
./install.sh
```

## What Gets Installed

The installer will set up:

- **Development Tools**: Git, curl, essential build tools
- **Language Runtimes**: Python (via pyenv), Node.js (via fnm), Rust
- **Version Managers**: asdf for managing multiple tool versions
- **Shell Enhancement**: Zsh with compatibility configuration
- **Dotfiles Manager**: chezmoi for configuration management
- **Platform-Specific Tools**:
  - macOS: Homebrew, Xcode Command Line Tools, TouchID sudo
  - Linux: Package manager updates, development packages

## Debug Mode

For troubleshooting, run with debug output:

```bash
# Remote with debug
curl -fsSL https://raw.githubusercontent.com/bossjones/zsh-dotfiles-prep/main/install.sh | bash -s -- --debug

# Local with debug
./install.sh --debug
```

## Next Steps

After installation completes:

1. **Restart your shell** or source the new configuration:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

2. **Install your dotfiles** using chezmoi:
   ```bash
   chezmoi init --apply https://github.com/yourusername/dotfiles.git
   ```

3. **Verify installation** by checking tool availability:
   ```bash
   python --version
   node --version
   cargo --version
   ```

## Troubleshooting

- **Permission Issues**: The installer may prompt for sudo access to install system packages
- **Network Issues**: Ensure you have internet connectivity for downloading packages
- **Platform Detection**: The installer automatically detects your OS; manual selection isn't needed
- **Homebrew on macOS**: Installation may take 10-15 minutes for initial Homebrew setup

For detailed troubleshooting, see the main [README.md](../README.md) or run with `--debug` flag.
