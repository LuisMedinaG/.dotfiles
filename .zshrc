#
# Luis Medina's ZSH Profile
# Managed with YADM
#

### ───── Load Core Configuration ─────
# Set locale and editor
export LC_ALL="en_US.UTF-8"
export EDITOR="code"

# Starship
# eval "$(starship init zsh)"

# Load essential ZSH options first
[ -f ~/.zsh/options.zsh ] && source ~/.zsh/options.zsh

### ───── Load Modular Configurations ─────
# Load all development tools (consolidated file)
[ -f ~/.zsh/tools.zsh ] && source ~/.zsh/tools.zsh

# Load aliases and functions
[ -f ~/.zsh/aliases.zsh ] && source ~/.zsh/aliases.zsh

### ───── History Settings ─────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

### ───── Prompt Configuration ─────
autoload -Uz colors && colors

# Basic prompt
PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%1~ %{$reset_color%}%# "
RPROMPT="%{$fg[yellow]%}%*%{$reset_color%}"

# Uncomment if you use Oh My Posh:
# eval "$(oh-my-posh init zsh)"
# eval "$(oh-my-posh --init --shell zsh --config $HOME/.zsh/adamnorwood.omp.json)"

## ───── LS Configuration ─────

# Add files and directories color when running ls
# There's a generator here: http://geoff.greer.fm/lscolors/
export CLICOLOR=1
export LS_COLORS='di=36:ln=1;35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export GREP_COLOR='1;35;40'

## ───── Syntax Highlighting ─────

# Run zsh-syntax-highlighting (installed via homebrew).
# See: https://github.com/zsh-users/zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### ───── Completion Configuration ─────

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
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=0
zstyle ':completion:*' original true
zstyle ':completion:*' prompt 'Did you mean?'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true

# Initialize the completion system
autoload -U compinit && compinit

### ───── Personal Environment ─────
# Load personal environment if it exists
[ -f ~/.zshenv ] && source ~/.zshenv
[ -f "$HOME/Documents/Code/Archives/pic-tools/scripts/env.zsh" ] && source "$_"

### ───── System-specific Configurations ─────
# System-specific configs are handled by YADM using alternative files:
# .zshrc##Darwin for macOS
# .zshrc##Linux for Linux

## ───── iTerm2 Shell Integration ─────

# See: https://iterm2.com/documentation-shell-integration.html
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
