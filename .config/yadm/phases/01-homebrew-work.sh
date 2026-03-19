#!/bin/sh
#
# Phase 1 (Work): Homebrew — CLI-only packages from Brewfile.work.
# No casks, no admin-required tools.
#
# Run standalone:  sh ~/.config/yadm/phases/01-homebrew-work.sh
#
set -eu

echo "═══ Phase 1 (Work): Homebrew — CLI only ═══"

# Only run on macOS
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Skipping Homebrew (not macOS)."
  exit 0
fi

# Check if Homebrew is available (IT may have pre-installed it)
if ! command -v brew >/dev/null 2>&1; then
  echo ""
  echo "Homebrew not found."
  echo "On a restricted work Mac, ask IT to install Homebrew, or try:"
  echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  echo ""
  echo "If that fails due to admin restrictions, you can still use the"
  echo "shell config — just without the modern CLI replacements (eza, bat, etc)."
  exit 1
fi

echo "Homebrew found. Updating..."
brew update
brew upgrade

# Install CLI-only packages from work Brewfile
BREWFILE="$HOME/.config/brew/Brewfile.work"
if [ -f "$BREWFILE" ]; then
  echo "Installing packages from Brewfile.work..."
  brew bundle install --file "$BREWFILE"
else
  echo "Warning: Brewfile.work not found at $BREWFILE" >&2
  exit 1
fi

echo "✓ Phase 1 (Work) complete."
