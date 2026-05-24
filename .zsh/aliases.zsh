#
# ZSH Aliases
#

# File operations
if command -v eza >/dev/null 2>&1; then
  alias l='eza --icons --group-directories-first -lha'
  alias ls='eza --icons --group-directories-first -l'
fi
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never --plain'
command -v rg >/dev/null 2>&1 && alias grep='rg'
# Note: 'grep' alias uses ripgrep syntax. Use \grep or command grep for POSIX grep.
command -v nvim >/dev/null 2>&1 && alias vim='nvim'

# Git/tmux/etc. shortcuts are defined as zsh-abbr abbreviations in
# ~/.config/zsh-abbr/user-abbreviations and loaded by the zsh-abbr plugin.

# Directory stack shortcuts
# Generate aliases d1, d2, ... for dirs stack
alias d='dirs -v'
for index in {1..9}; do
    alias "d$index"="cd +$index"
done
unset index

# Include custom aliases
source_if_exists ~/.aliases.local
