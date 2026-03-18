# Core environment variables ONLY - keep this file minimal

# ZSH directory structure
export ZSH=$HOME/.zsh
export ZDOTDIR="$HOME"

# Editor
export VISUAL=nvim
export EDITOR=$VISUAL

# Source function for other files to use
source_if_exists() {
  [ -r "$1" ] && [ -f "$1" ] && source "$1"
}

# ───── Homebrew ─────
# Must be in .zshenv (not .zprofile) so non-login shells (tmux, nested) get it too
if [ -z "$HOMEBREW_PREFIX" ]; then
  if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Local config
source_if_exists ~/.zshenv.local
