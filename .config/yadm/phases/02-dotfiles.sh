#!/bin/sh
#
# Phase 2: Dotfiles — checkout latest dotfiles and init submodules.
#
# Run standalone:  sh ~/.config/yadm/phases/02-dotfiles.sh
#
set -eu

echo "═══ Phase 2: Dotfiles ═══"

cd "$HOME" || exit 1

# Verify yadm is available
if ! command -v yadm >/dev/null 2>&1; then
  echo "Error: yadm not found. Run phase 01 first, or: brew install yadm" >&2
  exit 1
fi

echo "Ensuring dotfiles are checked out..."
yadm checkout 2>/dev/null || yadm checkout -f

echo "Pulling latest changes..."
yadm pull --rebase || echo "Warning: pull failed (maybe no remote set yet or first clone)."

echo "Updating submodules..."
yadm submodule update --init --recursive 2>/dev/null || echo "Warning: no submodules configured."

echo "Setting yadm alternates and permissions..."
yadm alt
yadm perms

echo "✓ Phase 2 complete."
