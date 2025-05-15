#
# Envitornment variables 
#

# ───── Core Configuration ─────
# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# ZSH
export ZSH=$HOME/.zsh
export ZDOTDIR="$HOME"
# TODO: Move zshrc to $ZDOTDIR, create symlink to $HOME/.zshrc
# ZDOTDIR=$HOME/.zsh

# Make VS Code the default editor.
export EDITOR=code

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Man pages
export MANPAGER='nvim +Man!'

# TODO: Move this to .zsprofile
# ───── Homebrew ─────
if [ -f /opt/homebrew/bin/brew ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

# Add curl from Homebrew to PATH
export PATH="$(brew --prefix curl)/bin:$PATH"

# ───── Python (pyenv) ─────
if command -v pyenv >/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# ───── Node.js (nvm) ─────
export NVM_DIR="$HOME/.nvm"

# TODO: Move functions to .zsh/functions.zsh 
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

# ───── Java (jenv) ─────
if command -v jenv >/dev/null; then
  eval "$(jenv init -)"
  
  # Set default Java version if the command exists
  if command -v /usr/libexec/java_home >/dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
  fi
  
  # TODO: Move PATH to .zsh/path.zsh
  # Maven configuration
  if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/maven" ]; then
    export M3_HOME="$HOMEBREW_PREFIX/opt/maven"
    export PATH="$PATH:$M3_HOME/bin"
  fi
fi

# ───── Oracle Instant Client ─────
# TODO: Move this to .zsh/exports.zsh
if [ -d "/opt/oracle/instantclient_23_3" ]; then
  export ORACLE_HOME="/opt/oracle/instantclient_23_3"
  export NLS_LANG="AMERICAN_AMERICA.UTF8"
  export LD_LIBRARY_PATH="$ORACLE_HOME"
  export DYLD_LIBRARY_PATH="$ORACLE_HOME"
  export PATH="$PATH:$ORACLE_HOME"
fi

# TODO: find where to put zsh config
# fzf

FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:red,\
marker:blue,\
prompt:gray,\
hl+:red"

# FZF_COLORS="bg+:#3F3F3F,bg:#4B4B4B,border:#6B6B6B,spinner:#98BC99,hl:#719872,fg:#D9D9D9,header:#719872,info:#BDBB72,pointer:#E12672,marker:#E17899,fg+:#D9D9D9,preview-bg:#3F3F3F,prompt:#98BEDE,hl+:#98BC99"

export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--color '$FZF_COLORS' \
--layout=reverse \
--info=inline --cycle \
--prompt '∷ ' \
--pointer=► \
--marker=✓"

export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Search command history
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
# Preview files
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --style=numbers --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)' --bind shift-up:preview-page-up,shift-down:preview-page-down"
# cd into the selected directory
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'tree -C {}'"

# ───── WORK ENVIRONMENT ─────
source_if_exists $HOME/.zsh/work_environment.zsh
