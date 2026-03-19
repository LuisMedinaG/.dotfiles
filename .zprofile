#
# This file is sourced by the Z shell (zsh) when it is started as a login shell.
#

# LANGUAGE
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# ───── Homebrew ─────
# Homebrew shellenv is loaded in .zshenv so non-login shells get it too.
# Here we only set paths that depend on HOMEBREW_PREFIX.
if [ -n "$HOMEBREW_PREFIX" ]; then
    # Path for Homebrew zsh-completions, used in completion.zsh
    export BREW_COMPLETIONS_PATH="$HOMEBREW_PREFIX/share/zsh-completions"
    export FORGIT_INSTALL_DIR="$HOMEBREW_PREFIX/share/forgit"

    # Add curl from Homebrew to PATH
    export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
fi

# ───── Language/Runtime Environments ─────
# Python (pyenv) — cached for faster login shells
if command -v pyenv >/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    _pyenv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/pyenv_init.zsh"
    if [ ! -f "$_pyenv_cache" ] || [ -n "$(find "$_pyenv_cache" -mtime +7 -print 2>/dev/null)" ]; then
        mkdir -p "$(dirname "$_pyenv_cache")"
        pyenv init - > "$_pyenv_cache"
    fi
    source "$_pyenv_cache"
    unset _pyenv_cache
fi

# Node.js (NVM setup, but not loading)
export NVM_DIR="$HOME/.nvm"
# Actual loading happens via functions.zsh lazy loading

# Java (jenv) — cached for faster login shells
if command -v jenv >/dev/null; then
    _jenv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/jenv_init.zsh"
    if [ ! -f "$_jenv_cache" ] || [ -n "$(find "$_jenv_cache" -mtime +7 -print 2>/dev/null)" ]; then
        mkdir -p "$(dirname "$_jenv_cache")"
        jenv init - > "$_jenv_cache"
    fi
    source "$_jenv_cache"
    unset _jenv_cache

    # Set default Java version (falls back gracefully if Java 17 isn't installed)
    if [ -x /usr/libexec/java_home ]; then
        JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null) && export JAVA_HOME
    fi

    # Maven configuration
    if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/maven" ]; then
        export M3_HOME="$HOMEBREW_PREFIX/opt/maven"
        export PATH="$PATH:$M3_HOME/bin"
    fi
fi
