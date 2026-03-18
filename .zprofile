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
# Support both Apple Silicon (/opt/homebrew) and Intel (/usr/local)
if [ -d "/opt/homebrew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -n "$HOMEBREW_PREFIX" ]; then
    # Path for Homebrew zsh-completions, used in completion.zsh
    export BREW_COMPLETIONS_PATH="$HOMEBREW_PREFIX/share/zsh-completions"
    export FORGIT_INSTALL_DIR="$HOMEBREW_PREFIX/share/forgit"

    # Add curl from Homebrew to PATH
    export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
fi

# ───── Language/Runtime Environments ─────
# Python (pyenv)
if command -v pyenv >/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Node.js (NVM setup, but not loading)
export NVM_DIR="$HOME/.nvm"
# Actual loading happens via functions.zsh lazy loading

# Java (jenv)
if command -v jenv >/dev/null; then
    eval "$(jenv init -)"

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

# Oracle Client — auto-detect version instead of hardcoding
ORACLE_DIR=$(find /opt/oracle/instantclient_* -maxdepth 0 -type d 2>/dev/null | sort -V | tail -1)
if [ -n "$ORACLE_DIR" ]; then
    export ORACLE_HOME="$ORACLE_DIR"
    export NLS_LANG="AMERICAN_AMERICA.UTF8"
    export DYLD_LIBRARY_PATH="$ORACLE_HOME"
    export PATH="$PATH:$ORACLE_HOME"
fi
unset ORACLE_DIR
