# Core environment variables ONLY - keep this file minimal
# Enable zsh profiling: ZPROF=1 zsh -i -c exit
[ "${ZPROF:-0}" = "1" ] && zmodload zsh/zprof

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
# Cache `brew shellenv` output (static PATH/env vars) to avoid a subprocess fork
# on every shell. Regenerated if missing or older than 7 days.
# Consistent with the pyenv/jenv/zoxide cache pattern in .zprofile / plugins/init.zsh.
if [ -z "$HOMEBREW_PREFIX" ]; then
  _brew_bin=""
  if [ "$(uname -m)" = arm64 ] && [ -x /opt/homebrew/bin/brew ]; then
    _brew_bin=/opt/homebrew/bin/brew
  elif [ -x /opt/homebrew/bin/brew ]; then
    _brew_bin=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    _brew_bin=/usr/local/bin/brew
  fi

  if [ -n "$_brew_bin" ]; then
    _brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/brew_shellenv.zsh"
    # Regenerate if file is missing, empty, or older than 7 days.
    if [ ! -s "$_brew_cache" ] || [ -n "$(find "$_brew_cache" -mtime +7 2>/dev/null)" ]; then
      mkdir -p "${_brew_cache%/*}"
      "$_brew_bin" shellenv > "$_brew_cache"
    fi
    source_if_exists "$_brew_cache"
    unset _brew_cache
  fi
  unset _brew_bin
fi

# Local config
source_if_exists ~/.zshenv.local
