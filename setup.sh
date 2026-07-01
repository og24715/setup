#!/usr/bin/env bash
set -euo pipefail

# Locate an existing Homebrew by filesystem path, not just $PATH: brew may be
# installed but not yet loaded into the current shell (e.g. right after a fresh
# install, or in a non-login shell).
find_brew() {
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$candidate" ] && { echo "$candidate"; return 0; }
  done
  command -v brew 2>/dev/null || return 1
}

# Install Homebrew only if it really isn't there.
if ! brew_path="$(find_brew)"; then
  # NONINTERACTIVE keeps the installer from blocking on its "Press RETURN"
  # prompt. Without it, when this script is piped (curl ... | sh) the installer
  # reads the rest of the script from stdin and the lines below (including
  # ansible-playbook) silently never run.
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_path="$(find_brew)"
else
  echo "brew is already installed: $brew_path"
fi

# Load brew into this shell so the steps below can find brew / ansible-playbook,
# whether brew was just installed or already present.
eval "$("$brew_path" shellenv)"

# Persist it for future shells (without appending a duplicate line each run).
if ! grep -q 'brew shellenv' "${HOME}/.zprofile" 2>/dev/null; then
  printf '\neval "$(%s shellenv)"\n' "$brew_path" >> "${HOME}/.zprofile"
fi

# ansible (idempotent: no-op if already installed)
brew install ansible

# clone setup repository
curl -OL https://github.com/og24715/setup/archive/refs/heads/main.zip
unzip -o main.zip
cd setup-main

# deploy ansible
# --ask-become-pass prompts for the macOS password so pkg-based casks
# (e.g. google-japanese-ime) can install; without it the cask task fails
# on the first cask that needs sudo and every cask after it is skipped.
ansible-playbook ansible/playbook.yml --ask-become-pass
