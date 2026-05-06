#!/bin/sh
#
# Pre-bootstrap: run this on a brand-new machine to set up dotfiles with chezmoi.
#
# Usage:
#   curl -sL <url>/pre_bootstrap.sh | sh               # personal (default)
#   curl -sL <url>/pre_bootstrap.sh | sh -s -- --work  # work (CLI only, no casks)
#
# What it does:
#   1. Installs Homebrew (macOS only, skipped if already present)
#   2. Installs chezmoi
#   3. Writes ~/.config/chezmoi/chezmoi.toml with the chosen profile
#   4. Runs `chezmoi init --apply` — clones the repo and applies dotfiles +
#      runs run_once_ scripts (Homebrew packages, shell setup, etc.)
#
set -eu

DOTFILES_PROFILE="personal"
for arg in "$@"; do
  case "$arg" in
    --work)     DOTFILES_PROFILE="work" ;;
    --linuxbox) DOTFILES_PROFILE="linuxbox" ;;
  esac
done
export DOTFILES_PROFILE

# ─── 1. Homebrew (macOS only) ──────────────────────────────────────────────────

if [ "$(uname -s)" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Put brew on PATH for the rest of this script
  if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  echo "Homebrew ready."
fi

# ─── 2. chezmoi ───────────────────────────────────────────────────────────────

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi..."
  if command -v brew >/dev/null 2>&1; then
    brew install chezmoi
  else
    # Linux: official install script, puts binary in ~/.local/bin
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi
echo "chezmoi ready."

# ─── 3. Per-machine config ────────────────────────────────────────────────────

CHEZMOI_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi"
mkdir -p "$CHEZMOI_CONFIG_DIR"
cat > "$CHEZMOI_CONFIG_DIR/chezmoi.toml" <<EOF
[data]
  dotfiles_profile = "$DOTFILES_PROFILE"
EOF
echo "Profile '$DOTFILES_PROFILE' written to $CHEZMOI_CONFIG_DIR/chezmoi.toml"

# ─── 4. Clone + apply ─────────────────────────────────────────────────────────

echo "Cloning dotfiles and applying (profile: $DOTFILES_PROFILE)..."
chezmoi init --apply https://github.com/LuisMedinaG/.dotfiles.git

echo ""
echo "Done! Open a new terminal to pick up all changes."
echo ""
echo "macOS personal — run macOS defaults (optional, review first):"
echo "  sh \"\$(chezmoi source-path)/scripts/04-macos.sh\""
