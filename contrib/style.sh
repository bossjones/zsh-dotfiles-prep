#!/bin/bash
set -e
cd "$(dirname "$0")/.."

[[ $1 == "--fix" ]] && STYLE_FIX="1"

# assert that any reference of sudo uses --askpass (or is whitelisted for another reason)
sudo_askpass_style() {
  local grep_regex_arg
  if [ "$(uname -s)" == "Darwin" ]; then
    grep_regex_arg="-E"
  else
    grep_regex_arg="-P"
  fi

  local violations
  violations=$(
    # find all sudo and filter out allowed calls
    grep --line-number "[^'\"]sudo " bin/zsh-dotfiles-prereq-installer |
      grep "$grep_regex_arg" -v "^\d*: *#" |
      grep -v "sudo --reset-timestamp" |
      grep -v "(for sudo access)" |
      grep -v "sudo mktemp" |
      grep -v "sudo chmod 1700" |
      grep -v "sudo bash -c \"cat > '\$SUDO_ASKPASS'\"" |
      grep -v "sudo --askpass" |
      grep -v 'sudo "$@"' |
      grep -v 'Configuring sudo authentication using TouchID:' |
      grep -v "sudo --validate" || true
  )

  if [ -n "$violations" ]; then
    cat <<EOS
Error: Use of sudo in zsh-dotfiles-prereq-installer script without the sudo_askpass function to use
askpass helper (to avoid reprompting a user for their sudo password).
Either use sudo_askpass or add legitimate use to whitelist in script/cibuild.
$violations
EOS
    exit 1
  fi
}

shell_style() {
  local shfmt_args="--indent 2 --simplify"

  if [ -n "$STYLE_FIX" ]; then
    for file in "$@"; do
      # Want to expand shfmt_args
      # shellcheck disable=SC2086
      shfmt $shfmt_args --write "$file" "$file"
      shellcheck --format=diff "${file}" | patch -p1
    done
  fi

  # Want to expand shfmt_args
  # shellcheck disable=SC2086
  shfmt ${shfmt_args} --diff "$@"

  shellcheck "$@"
}

sudo_askpass_style

shell_style bin/zsh-dotfiles-prereq-installer contrib/*
