#
# Consolidated Tools Configuration
# Contains: Homebrew, Python, Node.js, Java, Oracle, FZF, SSH
#

### ───── Homebrew ─────
if [ -f "/opt/homebrew/bin/brew" ]; then
  # macOS Apple Silicon
  export HOMEBREW_PREFIX="/opt/homebrew"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  
  # Add curl from Homebrew to PATH
  if [ -d "$HOMEBREW_PREFIX/opt/curl/bin" ]; then
    export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
  fi
elif [ -f "/usr/local/bin/brew" ]; then
  export HOMEBREW_PREFIX="/usr/local"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

### ───── Python (pyenv) ─────
if command -v pyenv >/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

### ───── Node.js (nvm) ─────
export NVM_DIR="$HOME/.nvm"

# Lazy loading NVM for faster shell startup
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() {
  unfunction node
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  node "$@"
}

npm() {
  unfunction npm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  npm "$@"
}

### ───── Java (jenv) ─────
if command -v jenv >/dev/null; then
  eval "$(jenv init -)"
  
  # Set default Java version if the command exists
  if command -v /usr/libexec/java_home >/dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
  fi
  
  # Maven configuration
  if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/maven" ]; then
    export M3_HOME="$HOMEBREW_PREFIX/opt/maven"
    export PATH="$PATH:$M3_HOME/bin"
  fi
fi

### ───── Oracle Instant Client ─────
if [ -d "/opt/oracle/instantclient_23_3" ]; then
  export ORACLE_HOME="/opt/oracle/instantclient_23_3"
  export NLS_LANG="AMERICAN_AMERICA.UTF8"
  export LD_LIBRARY_PATH="$ORACLE_HOME"
  export DYLD_LIBRARY_PATH="$ORACLE_HOME"
  export PATH="$PATH:$ORACLE_HOME"
fi

### ───── FZF (Fuzzy Finder) ─────
# To install useful key bindings and fuzzy completion:
# $(brew --prefix)/opt/fzf/install

# Basic fzf setup
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline --cycle --pointer=► --marker=✓'
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'

# CTRL-R - Search command history
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --style=numbers --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)' --bind shift-up:preview-page-up,shift-down:preview-page-down"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# FZF helper functions
# _fzf_compgen_path() { command -v fd >/dev/null && fd --hidden --follow --exclude ".git" . "$1"; }
# _fzf_compgen_dir() { command -v fd >/dev/null && fd --type d --hidden --follow --exclude ".git" . "$1"; }
# _fzf_comprun() {
#   local command=$1; shift
#   case "$command" in
#     cd|ls) fzf "$@" --preview 'tree -C {} | head -200' ;;
#     *) fzf "$@" ;;
#   esac
# }

### ───── SSH & Yubikey ─────
# Function to reload SSH keys with Yubikey
reload-ssh() {
  if command -v ssh-add >/dev/null; then
    ssh-add -e /usr/local/lib/opensc-pkcs11.so > /dev/null
    if [[ $? -gt 0 ]]; then echo "Failed to remove previous card"; fi
    ssh-add -s /usr/local/lib/opensc-pkcs11.so
  fi
}

### ───── Improving shell workflows with fzf ─────
# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
function activate-venv() {
  local selected_env
  selected_env=$(ls ~/.venv/ | fzf)

  if [ -n "$selected_env" ]; then
    source "$HOME/.venv/$selected_env/bin/activate"
  fi
}

# Start SCM agent socket if not running
[[ ! -a ~/.ssh/scm-agent.sock ]] && ssh-agent -a ~/.ssh/scm-agent.sock

# https://github.com/djui/alias-tips
# Zsh plugin to help remembering shell aliases
# zplug "djui/alias-tips"
