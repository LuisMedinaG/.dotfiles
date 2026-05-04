#!/bin/sh
#
# Phase 1: Homebrew — install or update Homebrew and all packages from Brewfile.
#
# Run standalone:  sh ~/.config/yadm/phases/01-homebrew.sh
#
set -eu

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
  echo "Homebrew found. Updating formulas..."
  brew update
  # Only upgrade installed packages when explicitly requested.
  # Set DOTFILES_UPGRADE=1 to run a full upgrade (e.g. on a dedicated maintenance pass).
  if [ "${DOTFILES_UPGRADE:-0}" = "1" ]; then
    echo "DOTFILES_UPGRADE=1: running brew upgrade..."
    brew upgrade
  else
    echo "Skipping brew upgrade (set DOTFILES_UPGRADE=1 to enable)."
  fi
fi

# Pick Brewfile based on profile
if [ "${DOTFILES_PROFILE:-personal}" = "work" ]; then
  BREWFILE="$HOME/.config/brew/Brewfile.work"
else
  BREWFILE="$HOME/.config/brew/Brewfile"
fi

if [ -f "$BREWFILE" ]; then
  echo "Installing packages from $(basename "$BREWFILE")..."
  brew bundle install --file "$BREWFILE"
else
  echo "Warning: Brewfile not found at $BREWFILE" >&2
  exit 1
fi

echo "✓ Phase 1 complete."
