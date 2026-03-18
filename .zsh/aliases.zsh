#
# ZSH Aliases
#

# File operations
alias l='eza --icons --group-directories-first -lha'
alias ls='eza --icons --group-directories-first -l'
alias cat='bat --paging=never --plain'
alias grep='rg'
# Note: 'grep' alias uses ripgrep syntax. Use \grep or command grep for POSIX grep.
alias vim='nvim'

# ZSH Abbr (https://zsh-abbr.olets.dev)
# Auto-expanding abbreviations, inspired by fish shell.
# Alias commented (using abbr ~/.config/zsh-abbr/user-abbreviations)

# Directory stack shortcuts
# Generate aliases d1, d2, ... for dirs stack
alias d='dirs -v'
for index in {1..9}; do
    alias "d$index"="cd +$index"
done
unset index

# Include custom aliases
source_if_exists ~/.aliases.local
