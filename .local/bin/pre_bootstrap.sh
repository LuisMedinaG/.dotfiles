#!/bin/sh
#
# Pre-bootstrap: run this on a brand-new Mac to kick off dotfiles setup.
# After this, yadm is installed via Homebrew and manages everything.
#
# Usage:
#   curl -sL <url>/pre_bootstrap.sh | sh               # full (personal)
#   curl -sL <url>/pre_bootstrap.sh | sh -s -- --work   # minimal (work)
#
set -eu

DOTFILES_PROFILE="personal"
for arg in "$@"; do
  case "$arg" in
    --work) DOTFILES_PROFILE="work" ;;
  esac
done
export DOTFILES_PROFILE

# 1. Install Homebrew (skip if already present)
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the rest of this script
  if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed."
fi

# 2. Install yadm via Homebrew (idempotent)
echo "Installing yadm..."
brew install yadm

# 3. Clone dotfiles — yadm bootstrap runs automatically
echo "Cloning dotfiles (profile: $DOTFILES_PROFILE)..."
yadm clone --bootstrap -f https://github.com/LuisMedinaG/.dotfiles.git

echo "Done! Open a new terminal to pick up all changes."
