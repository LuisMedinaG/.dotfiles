# 
# Luis Medina ZSH profile
# 

# Add Homebrew to the PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"

# See: https://iterm2.com/documentation-shell-integration.html
test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh" || true

# Add brew's version of curl to the PATH
export PATH="$(brew --prefix curl)/bin:$PATH"

# Locale
export LC_ALL="en_US.UTF-8"

# Run Oh My Posh prompt.
# See: https://ohmyposh.dev/
# eval "$(oh-my-posh --init --shell zsh --config $HOME/.zsh/adamnorwood.omp.json)"

# Aliases to make life easier.
alias ...='cd ../../'
alias ....='cd ../../../'
alias grep='grep --color=auto'
alias h='history 1'
alias ls='ls --color=auto'
alias l='ls -lAh'
alias python='/usr/local/bin/python3'
alias g='git'
alias gpl='git pull'
alias gps='git push'
alias gc='git checkout'
alias ghc='git rev-parse HEAD | pbcopy'
alias gsc='git branch --show-current | pbcopy'


# Set up Zsh options. There are many of these that can be tweaked!
# See: https://zsh.sourceforge.io/Doc/Release/Options.html
setopt alwaystoend
setopt appendhistory
setopt autocd
setopt autolist
setopt automenu
setopt autopushd
setopt completeinword
setopt correct
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignoredups
setopt histignorespace
setopt histverify
setopt interactivecomments
setopt listpacked
setopt longlistjobs
setopt nocaseglob
setopt noflowcontrol
setopt promptsubst
setopt pushdignoredups
setopt pushdminus
setopt sharehistory

# See: https://thevaluable.dev/zsh-install-configure-mouseless/
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Profile
autoload -Uz colors && colors
PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%1~ %{$reset_color%}%# "
RPROMPT="%{$fg[yellow]%}%*%{$reset_color%}"

# eval "$(oh-my-posh init zsh)"

# Enable color support
autoload -U colors
colors

# Set up zsh up/down/home/end key search completions.
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -e
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# bindkey "[C" forward-word
# bindkey "[D" backward-word


# Define a custom backward delete word function
backward_delete_word() {
  local WORDCHARS='_'
  zle backward-kill-word
}
zle -N backward_delete_word
bindkey '^W' backward_delete_word

# Set editor
export EDITOR="code"

# Add files and directories color when running ls
# There's a generator here: http://geoff.greer.fm/lscolors/
# export CLICOLOR=1
# export LS_COLORS='di=36:ln=1;35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
# export GREP_COLOR='1;35;40'

# jenv (for multiple java jdk versions)
eval "$(jenv init -)"

# zsh-syntax-highlighting
# See: https://github.com/zsh-users/zsh-syntax-highlighting
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History settings
# No duplicate history when reverse-searching my commands
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Load zsh completion system
source ~/.zsh/completion.zsh

# Case insensitive completion
# Trick out the zsh completion engine.
# See: https://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_23.html
# The following lines were added by compinstall
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=0
zstyle ':completion:*' original true
zstyle ':completion:*' prompt 'Did you mean?'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true

# Load additional plugins if needed
# Example: plugins=(git)

# Environment
export PATH="/usr/local/bin:$HOME/.jenv/bin:/opt/homebrew/opt/openjdk@17/bin:/opt/homebrew/bin/jenv:$PATH"
export HOMEBREW_AUTO_UPDATE_SECS=86400

# Essentials

# oh-my-posh
# See: https://ohmyposh.dev/

# fzf
# See: https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline' 

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --style=numbers --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)' --bind shift-up:preview-page-up,shift-down:preview-page-down"

# A simple, fast and user-friendly alternative to find.
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# # Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    ls)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

# fh() {
#   eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
# }

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# ack
# See: https://beyondgrep.com/

# ack.vim
# See: https://github.com/mileszs/ack.vim

# bat
# See: https://github.com/sharkdp/bat

# forgit
# See: https://github.com/wfxr/forgit

# (Optional) More plugins, tools, themes, etc.
# https://github.com/alebcay/awesome-shell

# Tmux
# https://github.com/tmux/tmux/wiki
# https://hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/

# zsh-bd
# . $HOME/.zsh/plugins/bd/bd.zsh

# Just adding a fun image for when the shell first opens. Why? Because I can.
# Require imgcat: https://github.com/eddieantonio/imgcat
# imgcat ~/Pictures/bubble-bobble.png

# Yubikey handler
reload-ssh() {
   ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
   if [ $? -gt 0 ]; then
       echo "Failed to remove previous card"
   fi
   ssh-add -s /usr/local/lib/opensc-pkcs11.so
}

# Environmemnt
source ~/.zshenv

## pic-tools
source $HOME/Documents/Code/Archives/pic-tools/scripts/*.env

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/lumedina/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SCM
if [[ ! -a ~/.ssh/scm-agent.sock ]]; then ssh-agent -a ~/.ssh/scm-agent.sock; fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
