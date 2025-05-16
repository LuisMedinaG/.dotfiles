#
# This file is sourced by the Z shell (zsh) when it is started as a login shell.
#

# LANGUAGE
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ───── Homebrew ─────
if [ -f /opt/homebrew/bin/brew ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

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

    # Set default Java version
    if command -v /usr/libexec/java_home >/dev/null; then
        export JAVA_HOME=$(/usr/libexec/java_home -v 17)
    fi

    # Maven configuration
    if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/maven" ]; then
        export M3_HOME="$HOMEBREW_PREFIX/opt/maven"
        export PATH="$PATH:$M3_HOME/bin"
    fi
fi

# Oracle Client
if [ -d "/opt/oracle/instantclient_23_3" ]; then
    export ORACLE_HOME="/opt/oracle/instantclient_23_3"
    export NLS_LANG="AMERICAN_AMERICA.UTF8"
    export LD_LIBRARY_PATH="$ORACLE_HOME"
    export DYLD_LIBRARY_PATH="$ORACLE_HOME"
    export PATH="$PATH:$ORACLE_HOME"
fi

# Source work environment early if it exists
source_if_exists $ZSH/.zsh/work_environment.zsh
