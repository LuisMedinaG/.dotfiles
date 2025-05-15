#
# Consolidated Tools Configuration
# Contains: Homebrew, Python, Node.js, Java, Oracle, FZF, SSH
#

# ───── Homebrew ─────
# Add Homebrew to the PATH
if [ -f /opt/homebrew/bin/brew ]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
fi

if [ -d $HOME/.local/bin ]; then
  export PATH="$HOME/.local/bin":$PATH
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
  
  # Maven configuration
  if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/maven" ]; then
    export M3_HOME="$HOMEBREW_PREFIX/opt/maven"
    export PATH="$PATH:$M3_HOME/bin"
  fi
fi

# ───── Oracle Instant Client ─────
if [ -d "/opt/oracle/instantclient_23_3" ]; then
  export ORACLE_HOME="/opt/oracle/instantclient_23_3"
  export NLS_LANG="AMERICAN_AMERICA.UTF8"
  export LD_LIBRARY_PATH="$ORACLE_HOME"
  export DYLD_LIBRARY_PATH="$ORACLE_HOME"
  export PATH="$PATH:$ORACLE_HOME"
fi

# Man pages
export MANPAGER='nvim +Man!'

# ───── Zoxide ─────
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# ───── Broot ───── 
# source $HOME/.config/broot/launcher/bash/br

# Completion 
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh
# Uses https://github.com/zsh-users/zsh-completions
source ~/.zsh/completion.zsh

# fzf
# https://github.com/junegunn/fzf
source ~/.fzf.zsh

# https://github.com/zsh-users/zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh plugin to help remembering shell aliases
# https://github.com/djui/alias-tips
source ~/.zsh/plugins/alias-tips/alias-tips.plugin.zsh

# https://github.com/Aloxaf/fzf-tab
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# See: https://github.com/zsh-users/zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/amaya382/zsh-fzf-widgets
# source ~/.zsh/plugins/zsh-fzf-widgets/zsh-fzf-widgets.zsh
# bindkey '^K' fzf-cdr

# https://github.com/junegunn/fzf-git.sh
# source ~/.zsh/plugins/fzf-git.sh

# See: https://iterm2.com/documentation-shell-integration.html
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
