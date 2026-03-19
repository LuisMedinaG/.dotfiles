#!/bin/sh
#
# Phase 3: Shell — configure fzf key bindings, create needed directories.
#
# Run standalone:  sh ~/.config/yadm/phases/03-shell.sh
#
set -eu

echo "═══ Phase 3: Shell setup ═══"

# Determine Homebrew prefix
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix)"
else
  echo "Warning: Homebrew not found, skipping fzf install." >&2
  BREW_PREFIX=""
fi

# Install fzf key bindings and completion (non-interactive)
if [ -n "$BREW_PREFIX" ] && [ -x "$BREW_PREFIX/opt/fzf/install" ]; then
  echo "Installing fzf key bindings and completion..."
  "$BREW_PREFIX/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
else
  echo "Skipping fzf setup (not installed)."
fi

# Create directories that configs expect to exist
echo "Creating required directories..."
mkdir -p "$HOME/.local/state/nvim/undo"   # neovim persistent undo
mkdir -p "$HOME/.cache/zsh"               # zsh completion cache
mkdir -p "$HOME/.venv"                    # python virtualenvs

if [ "${DOTFILES_PROFILE:-personal}" != "work" ]; then
  mkdir -p "$HOME/.config/mackup/backup"  # mackup app settings storage
fi

echo "✓ Phase 3 complete."
