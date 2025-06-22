#!/bin/bash
# Use bash as the interpreter for this script

set -e
# Exit immediately if a command exits with a non-zero status (error)

cd "$(dirname "$0")/.."
# Change directory to the parent directory of where this script is located

[[ $1 == "--fix" ]] && STYLE_FIX="1"
# If first argument is "--fix", set STYLE_FIX variable to "1" (enables auto-fixing)

# assert that any reference of sudo uses --askpass (or is whitelisted for another reason)
sudo_askpass_style() {
  local grep_regex_arg
  # Declare local variable for grep regex argument

  if [ "$(uname -s)" == "Darwin" ]; then
    # Check if operating system is macOS (Darwin)
    grep_regex_arg="-E"
    # Use extended regular expressions for macOS
  else
    grep_regex_arg="-P"
    # Use Perl-compatible regular expressions for other systems
  fi

  local violations
  # Declare local variable to store sudo violations

  violations=$(
    # Find all sudo violations by:
    # find all sudo and filter out allowed calls
    grep --line-number "[^'\"]sudo " bin/zsh-dotfiles-prereq-installer |
      # Find lines with sudo command and show line numbers
      grep "$grep_regex_arg" -v "^\d*: *#" |
      # Filter out commented lines
      grep -v "sudo --reset-timestamp" |
      # Filter out allowed use: reset timestamp
      grep -v "(for sudo access)" |
      # Filter out allowed use: sudo access comment
      grep -v "sudo mktemp" |
      # Filter out allowed use: sudo mktemp
      grep -v "sudo chmod 1700" |
      # Filter out allowed use: sudo chmod 1700
      grep -v "sudo bash -c \"cat > '\$SUDO_ASKPASS'\"" |
      # Filter out allowed use: writing to SUDO_ASKPASS
      grep -v "sudo --askpass" |
      # Filter out correct usage: with --askpass
      grep -v 'sudo "$@"' |
      # Filter out allowed use: passing arguments to sudo
      grep -v 'Configuring sudo authentication using TouchID:' |
      # Filter out allowed use: TouchID config message
      grep -v "sudo --validate" || true
    # Filter out allowed use: sudo validate, return true if no matches
  )

  if [ -n "$violations" ]; then
    # If violations variable is not empty (violations found)
    cat <<EOS
Error: Use of sudo in zsh-dotfiles-prereq-installer script without the sudo_askpass function to use
askpass helper (to avoid reprompting a user for their sudo password).
Either use sudo_askpass or add legitimate use to whitelist in script/cibuild.
$violations
EOS
    # Print error message with details about violations
    exit 1
    # Exit with error status
  fi
}

shell_style() {
  local shfmt_args="--indent 2 --simplify"
  # Set shell formatting arguments: 2-space indentation and simplify

  if [ -n "$STYLE_FIX" ]; then
    # If STYLE_FIX is set (fix mode enabled)
    for file in "$@"; do
      # Loop through each file argument
      # Want to expand shfmt_args
      # shellcheck disable=SC2086
      shfmt $shfmt_args --write "$file" "$file"
      # Format the file with shfmt and write changes
      shellcheck --format=diff "${file}" | patch -p1
      # Run shellcheck to generate fixes and apply them as patches
    done
  fi

  # Want to expand shfmt_args
  # shellcheck disable=SC2086
  shfmt ${shfmt_args} --diff "$@"
  # Show formatting differences for all files

  shellcheck "$@"
  # Run shellcheck linter on all files
}

sudo_askpass_style
# Run the sudo_askpass_style check

shell_style bin/zsh-dotfiles-prereq-installer bin/zsh-dotfiles-prereq-installer-linux contrib/* install.sh
# Run shell_style check/fix on specified files
