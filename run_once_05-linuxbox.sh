#!/bin/sh
#
# Phase 5: Linux dev box — system packages not available via Homebrew.
#
# chezmoi runs this exactly once (re-runs only if this file's content changes).
#
set -eu

echo "═══ Phase 5: Linux tooling ═══"

if [ "$(uname -s)" != "Linux" ]; then
  echo "Skipping (not Linux)."
  exit 0
fi

# Abort early if sudo isn't available (non-interactive CI etc.)
if ! command -v sudo >/dev/null 2>&1; then
  echo "Warning: sudo not found, skipping package installs." >&2
  exit 0
fi

# ─── apt packages ─────────────────────────────────────────────────────────────

sudo apt-get update -qq

# neovim — editor ($VISUAL / $EDITOR in .zshenv)
if ! command -v nvim >/dev/null 2>&1; then
  echo "Installing neovim..."
  sudo apt-get install -y --no-install-recommends neovim
fi

# zoxide — smart cd (zsh init in plugins/init.zsh)
if ! command -v zoxide >/dev/null 2>&1; then
  echo "Installing zoxide..."
  sudo apt-get install -y --no-install-recommends zoxide
fi

# ─── eza (modern ls, not in Ubuntu main repos) ────────────────────────────────

if ! command -v eza >/dev/null 2>&1; then
  echo "Installing eza..."
  sudo apt-get install -y --no-install-recommends gpg
  # Official eza deb repo (https://github.com/eza-community/eza/blob/main/INSTALL.md)
  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/gierens.gpg] \
http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends eza
fi

# ─── pipx + shell-ai ──────────────────────────────────────────────────────────

if ! command -v pipx >/dev/null 2>&1; then
  echo "Installing pipx..."
  sudo apt-get install -y --no-install-recommends pipx
fi

if ! pipx list 2>/dev/null | grep -q shell-ai; then
  echo "Installing shell-ai..."
  pipx install shell-ai
else
  echo "shell-ai already installed."
fi

# ─── required directories (mirrors 03-shell for Linux) ────────────────────────

mkdir -p "$HOME/.local/state/nvim/undo"
mkdir -p "$HOME/.cache/zsh"
mkdir -p "$HOME/.venv"

echo "✓ Phase 5 complete."
