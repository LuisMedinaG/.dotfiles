#
# Luis Medina's ZSH Profile
#

### ───── Locale & Editor ─────
export LC_ALL="en_US.UTF-8"
export EDITOR="code"

### ───── Aliases ─────
alias ...='cd ../../'
alias ....='cd ../../../'
alias grep='grep --color=auto'
alias h='history 1'
alias l='ls -lAh'

# Git Shortcuts
alias g='git'
alias gpl='git pull'
alias gps='git push'
alias gc='git checkout'
alias ghc='git rev-parse HEAD | pbcopy'
alias gsc='git branch --show-current | pbcopy'

### ───── Zsh Options ─────
setopt autocd             # cd into dir without typing 'cd'
setopt appendhistory      # Append to history, don't overwrite
setopt sharehistory       # Share command history across sessions
setopt histignoredups     # Ignore duplicate commands in history
setopt incappendhistory   # Write to history immediately
setopt hist_ignore_all_dups hist_save_no_dups hist_find_no_dups histignorespace histverify extendedhistory
setopt correct            # Auto-correct minor command misspellings
setopt interactivecomments
setopt nocaseglob         # Case-insensitive globbing
setopt promptsubst
setopt alwaystoend
setopt autolist automenu completeinword
setopt pushdignoredups pushdminus autopushd pushd_silent

### ───── Prompt ─────
autoload -Uz colors && colors
PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%1~ %{$reset_color%}%# "
RPROMPT="%{$fg[yellow]%}%*%{$reset_color%}"
# Uncomment if you use Oh My Posh:
# eval "$(oh-my-posh init zsh)"
# eval "$(oh-my-posh --init --shell zsh --config $HOME/.zsh/adamnorwood.omp.json)"

### ───── Homebrew ─────
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$(brew --prefix curl)/bin:$PATH"

### ───── Language Environments ─────
# Python (pyenv)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Node.js (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Java (jenv and default 17)
eval "$(jenv init -)"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Maven
export M3_HOME="$(brew --prefix maven)"
export PATH="$PATH:$M3_HOME/bin"

# Oracle Instant Client
export ORACLE_HOME="/opt/oracle/instantclient_23_3"
export NLS_LANG="AMERICAN_AMERICA.UTF8"
export LD_LIBRARY_PATH="$ORACLE_HOME"
export DYLD_LIBRARY_PATH="$ORACLE_HOME"
export PATH="$PATH:$ORACLE_HOME"

### ───── History Settings ─────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

### ───── Directory Stack Shortcuts ─────
alias d='dirs -v'
for index ({1..9}); do alias "$index"="cd +$index"; done

### ───── Key Bindings ─────
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -e
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# Custom word deletion
backward_delete_word() {
  local WORDCHARS='_'
  zle backward-kill-word
}
zle -N backward_delete_word
bindkey '^W' backward_delete_word

### ───── fzf Setup ─────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_COMPLETION_TRIGGER='~~'
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --style=numbers --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)' --bind shift-up:preview-page-up,shift-down:preview-page-down"

# fzf custom commands
_fzf_compgen_path() { fd --hidden --follow --exclude ".git" . "$1" }
_fzf_compgen_dir() { fd --type d --hidden --follow --exclude ".git" . "$1" }
_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd|ls) fzf "$@" --preview 'tree -C {} | head -200' ;;
    *) fzf "$@" ;;
  esac
}

### ───── Completion Engine ─────
autoload -U compinit && compinit
source ~/.zsh/completion.zsh
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

### ───── SSH & Yubikey Tools ─────
reload-ssh() {
  ssh-add -e /usr/local/lib/opensc-pkcs11.so > /dev/null
  if [[ $? -gt 0 ]]; then echo "Failed to remove previous card"; fi
  ssh-add -s /usr/local/lib/opensc-pkcs11.so
}

# Start SCM agent socket if not running
[[ ! -a ~/.ssh/scm-agent.sock ]] && ssh-agent -a ~/.ssh/scm-agent.sock

### ───── Custom Shortcuts & Tools ─────
v() { open "$1" -a "Visual Studio Code"; }

# Personal env vars
[ -f ~/.zshenv ] && source ~/.zshenv
[ -f "$HOME/Documents/Code/Archives/pic-tools/scripts/env.zsh" ] && source "$_"

### ───── Rancher Desktop (Auto-managed) ─────
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/lumedina/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
