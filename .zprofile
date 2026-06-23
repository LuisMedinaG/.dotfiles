#
# This file is sourced by the Z shell (zsh) when it is started as a login shell.
#

# LANGUAGE
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# After macOS path_helper (/etc/zprofile): put Apple Silicon Homebrew first.
# .zshenv already ran brew shellenv; avoid eval twice — prepend + dedupe PATH only.
if [ "$(uname -m)" = arm64 ] && [ -x /opt/homebrew/bin/brew ]; then
  PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export PATH
  typeset -U path PATH
fi

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# ───── Homebrew ─────
# Here we only set paths that depend on HOMEBREW_PREFIX.
if [ -n "$HOMEBREW_PREFIX" ]; then
    # Path for Homebrew zsh-completions, used in completion.zsh
    export BREW_COMPLETIONS_PATH="$HOMEBREW_PREFIX/share/zsh-completions"

    # Add curl from Homebrew to PATH
    export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
fi

# Node.js (NVM dir only — actual loading is lazy via functions.zsh)
export NVM_DIR="$HOME/.nvm"

# Local overrides (machine-specific login-shell config)
source_if_exists ~/.zprofile.local
