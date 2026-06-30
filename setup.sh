#!/usr/bin/env bash
set -euo pipefail

# brew
if ! command -v brew &>/dev/null; then
  # NONINTERACTIVE keeps the installer from blocking on its "Press RETURN"
  # prompt. Without it, when this script is piped (curl ... | sh) the installer
  # reads the rest of the script from stdin and the lines below (including
  # ansible-playbook) silently never run.
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
else
  echo "brew has already installed"
fi

# load brew into the current shell's PATH (Apple Silicon / Intel)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ansible
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
