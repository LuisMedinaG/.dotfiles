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

### ───── Prompt Configuration ─────
# Load colors
autoload -Uz colors && colors

# Basic prompt
PS1="%{$fg[cyan]%}%n@%m %{$fg[green]%}%1~ %{$reset_color%}%# "
RPROMPT="%{$fg[yellow]%}%*%{$reset_color%}"

# Uncomment if you use Oh My Posh:
# eval "$(oh-my-posh init zsh)"
# eval "$(oh-my-posh --init --shell zsh --config $HOME/.zsh/adamnorwood.omp.json)"

### ───── Completion Configuration ─────
# Initialize the completion system
autoload -U compinit && compinit

# Completion styles
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*:git-checkout:*' sort false

### ───── History Settings ─────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

### ───── Personal Environment ─────
# Load personal environment if it exists
[ -f ~/.zshenv ] && source ~/.zshenv
[ -f "$HOME/Documents/Code/Archives/pic-tools/scripts/env.zsh" ] && source "$_"

### ───── System-specific Configurations ─────
# System-specific configs are handled by YADM using alternative files:
# .zshrc##Darwin for macOS
# .zshrc##Linux for Linux

### ───── Third-party Managed Sections ─────
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/lumedina/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
