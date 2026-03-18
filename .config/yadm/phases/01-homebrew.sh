#!/bin/sh
#
# Phase 1: Homebrew — install or update Homebrew and all packages from Brewfile.
#
# Run standalone:  sh ~/.config/yadm/phases/01-homebrew.sh
#
set -e

echo "═══ Phase 1: Homebrew ═══"

# Only run on macOS
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Skipping Homebrew (not macOS)."
  exit 0
fi

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Put brew on PATH for the rest of the script
  if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "Homebrew found. Updating..."
  brew update
  brew upgrade
fi

# Install packages from Brewfile
BREWFILE="$HOME/.config/brew/Brewfile"
if [ -f "$BREWFILE" ]; then
  echo "Installing packages from Brewfile..."
  brew bundle install --file "$BREWFILE" --no-lock
else
  echo "Warning: Brewfile not found at $BREWFILE" >&2
  exit 1
fi

echo "✓ Phase 1 complete."
