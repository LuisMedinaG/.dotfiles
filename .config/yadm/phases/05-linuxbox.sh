#!/bin/sh
#
# Phase 5: Linux dev box — system packages not available via Homebrew.
#
# Run standalone:  sh ~/.config/yadm/phases/05-linuxbox.sh
#
set -eu

echo "═══ Phase 5: Linux tooling ═══"

if [ "$(uname -s)" != "Linux" ]; then
  echo "Skipping (not Linux)."
  exit 0
fi

# ─── apt packages ────────────────────────────────────────────────────────────

# Check if sudo apt-get is usable (may be restricted on managed machines where
# a separate bootstrap already installed these tools).
_can_sudo_apt() {
  command -v sudo >/dev/null 2>&1 && sudo -n apt-get --version >/dev/null 2>&1
}

_apt_updated=0
_apt_update_once() {
  if [ "$_apt_updated" -eq 0 ]; then
    sudo apt-get update -qq
    _apt_updated=1
  fi
}

if ! command -v nvim >/dev/null 2>&1; then
  if _can_sudo_apt; then
    echo "Installing neovim..."
    _apt_update_once
    sudo apt-get install -y --no-install-recommends neovim
  else
    echo "Warning: neovim not found and sudo apt-get not available — install manually." >&2
  fi
fi

if ! command -v zoxide >/dev/null 2>&1; then
  if _can_sudo_apt; then
    echo "Installing zoxide..."
    _apt_update_once
    sudo apt-get install -y --no-install-recommends zoxide
  else
    echo "Warning: zoxide not found and sudo apt-get not available — install manually." >&2
  fi
fi

# ─── eza (modern ls, not in Ubuntu main repos) ───────────────────────────────

if ! command -v eza >/dev/null 2>&1; then
  if _can_sudo_apt; then
    echo "Installing eza..."
    _apt_update_once
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
  else
    echo "Warning: eza not found and sudo apt-get not available — install manually." >&2
  fi
fi

echo "✓ Phase 5 complete."
