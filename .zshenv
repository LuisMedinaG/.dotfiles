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
  # Cover Apple Silicon, Intel macOS, Linuxbrew, and any custom PATH-based install.
  if [ -x /opt/homebrew/bin/brew ]; then
    _brew_bin=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    _brew_bin=/usr/local/bin/brew
  elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    _brew_bin=/home/linuxbrew/.linuxbrew/bin/brew
  elif command -v brew >/dev/null 2>&1; then
    _brew_bin="$(command -v brew)"
  fi

  if [ -n "$_brew_bin" ]; then
    _brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/brew_shellenv.zsh"
    # Regenerate if file is missing, empty, or older than 7 days.
    if [ ! -s "$_brew_cache" ] || [ -n "$(find "$_brew_cache" -mtime +7 2>/dev/null)" ]; then
      mkdir -p "${_brew_cache%/*}"
      # Atomic write: temp file in same dir, then rename. Avoids a partially
      # written cache being sourced by a concurrent shell.
      _brew_tmp="${_brew_cache}.tmp.$$"
      if "$_brew_bin" shellenv > "$_brew_tmp" 2>/dev/null; then
        mv "$_brew_tmp" "$_brew_cache"
      else
        rm -f "$_brew_tmp"
      fi
      unset _brew_tmp
    fi
    source_if_exists "$_brew_cache"
    unset _brew_cache
  fi
  unset _brew_bin
fi

# Local config
source_if_exists ~/.zshenv.local
